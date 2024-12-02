import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/auth/run_session.dart';
import 'package:jogging/auth/user.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserRepository {
  UserRepository({
    required this.prefs,
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final RxSharedPreferences prefs;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final _db = FirebaseFirestore.instance;

  Future<Either<CreateUserFailure, User>> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int age,
    required Sex sex,
    required String description,
  }) async {
    try {
      final userCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredentials.user == null) {
        return const Left(CreateUserFailure.unknownFailure);
      }
      User user = User(
        description: description,
        email: email,
        uid: userCredentials.user!.uid,
        firstName: firstName,
        lastName: lastName,
        sex: sex,
        age: age,
        numberOfRuns: 0,
      );
      await _db
          .collection("users")
          .doc(userCredentials.user!.uid)
          .set(user.toJson());
      return Right(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapCreateUserFailures(e.code));
    }
  }

  Future<Either<LoginFailure, User>> login(
      {required String email, required String password}) async {
    try {
      final userInfo = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userInfo.user == null) {
        return const Left(LoginFailure.wrongCredentials);
      }
      String uid = userInfo.user!.uid;
      final userValues = await _db.collection("users").doc(uid).get();
      if (userValues.data() == null || userValues.data()!.isEmpty) {
        return const Left(LoginFailure.noDataInsertedYet);
      }
      return Right(User.fromJson(userValues.data()!, id: uid));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapLoginFailures(e.code));
    }
  }

  Stream<String?> userIdString() {
    return _firebaseAuth.authStateChanges().map((firebase_auth.User? user) {
      if (user == null) {
        return null;
      } else {
        return user.uid;
      }
    });
  }

  Future<RunSession?> returnRunData(User user, String runName) async {
    try {
      final runCollection = await _db
          .collection("users")
          .doc(user.uid)
          .collection(runName)
          .doc("run_info")
          .get();
      Map<String, dynamic>? mapValues = runCollection.data();
      if (mapValues == null) return null;
      return RunSession.fromJson(mapValues, user);
    } on FirebaseException catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> writePositionsToDatabase(RunSession runSession) async {
    try {
      await _db
          .collection("users")
          .doc(runSession.user.uid)
          .collection("run_${runSession.user.numberOfRuns}")
          .doc('run_info')
          .set(runSession.convertToDatabaseOut());
      await _db.collection("users").doc(runSession.user.uid).update({
        "numberOfRuns": runSession.user.numberOfRuns + 1,
      });
    } on FirebaseException {
      print("A picat si nu e bine ca nu a mers scrierea");
    }
  }

  void updateUserInformation(User user) async {
    Map<String, dynamic> updateInfo = {
      "firstName": user.firstName,
      "lastName": user.lastName,
      'sex': user.sex.toName(),
      'age': user.age,
    };
    try {
      await _db.collection("users").doc(user.uid).update(updateInfo);
      prefs.setString('user_data', user.toSharedPreferences());
    } on FirebaseException {
      print("nu este internet");
    }
  }

  Future<User?> getUserFromMemory() async {
    String? data = await prefs.getString('user_data');
    if (data == null) return null;
    Map<String, dynamic> userData = jsonDecode(data) as Map<String, dynamic>;
    return User(
      description: userData['description'],
      age: userData['age'],
      uid: userData['uid'],
      email: userData['email'],
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      sex: Sex.fromName(userData['sex']),
      numberOfRuns: userData['numberOfRuns'],
    );
  }

  Future<User?> getUserFromDatabase(String id) async {
    final userValues = await _db.collection("users").doc(id).get();
    if (userValues.data() == null || userValues.data()!.isEmpty) {
      return null;
    }
    return User.fromJson(userValues.data()!, id: id);
  }

  Future<void> deleteUserFromMemory() async {
    final keyIsContained = await prefs.containsKey('user_data');
    if (keyIsContained) {
      print("S-au gasit datele user-ului care vor fi sterse");
      await prefs.remove('user_data');
      return;
    }
    print("Nu s-a gasit nimic despre user in shared preferences");
  }

  Future<void> writeUserToMemory(User user) async {
    await prefs.updateString('user_data', (p0) => user.toSharedPreferences());
  }

  Future<CreateUserFailure?> addUserToDatabase({required User user}) async {
    try {
      await _db.collection("users").doc(user.uid).set(user.toJson());
      return null;
    } on FirebaseException {
      return CreateUserFailure.unknownFailure;
    }
  }

  LoginFailure _mapLoginFailures(String errorCode) {
    return switch (errorCode) {
      "wrong-password" => LoginFailure.wrongCredentials,
      "network-request-failed" => LoginFailure.noInternetConnection,
      "user-not-found" => LoginFailure.wrongCredentials,
      "invalid-email" => LoginFailure.invalidEmail,
      "invalid-credential" => LoginFailure.wrongCredentials,
      _ => LoginFailure.unknown,
    };
  }

  CreateUserFailure _mapCreateUserFailures(String errorCode) {
    return switch (errorCode) {
      "email-already-in-use" => CreateUserFailure.emailInUseFailure,
      "invalid-email" => CreateUserFailure.invalidEmailFailure,
      "operation-not-allowed" => CreateUserFailure.operationNotPermittedFailure,
      "weak-password" => CreateUserFailure.weakPasswordFailure,
      _ => CreateUserFailure.unknownFailure,
    };
  }

  Stream<User?> getLocalUserStream() {
    return prefs.getStringStream('user_data').map((data) {
      if (data == null) return null;
      return User.fromSharedPreferences(data);
    });
  }
}
