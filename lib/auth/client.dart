import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:jogging/auth/failures.dart';
import 'package:jogging/auth/user.dart';

class AuthenticationClient {
  AuthenticationClient({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final _db = FirebaseFirestore.instance;

  Future<CreateUserFailure?> addUserToDatabase({required User user}) async {
    try {
      await _db.collection("users").doc(user.uid).set(user.toJson());
      return null;
    } on FirebaseException {
      return CreateUserFailure.unknownFailure;
    }
  }

  Future<Either<CreateUserFailure, User>> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int age,
    required Sex sex,
  }) async {
    try {
      final userCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredentials.user == null) {
        return const Left(CreateUserFailure.unknownFailure);
      }
      User user = User(
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

  Future<void> updateUserInformation(User user) async {
    Map<String, String> updateInfo = {
      "firstName": user.firstName,
      "lastName": user.lastName,
      'sex': user.sex.toName(),
      'age': user.age.toString(),
    };
    try {
      await _db.collection("users").doc(user.uid).update(updateInfo);
    } on FirebaseException {
      print("nu este internet");
    }
  }

  Future<Either<LoginFailure, User>> login(
      String email, String password) async {
    try {
      final userInfo = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userInfo.user == null) {
        return const Left(LoginFailure.wrongCredentials);
      }
      // aici s-ar putea sa fie probleme
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

  Future<void> writePositionsToDatabase(
      {required String positions, required User user, required int noStep}) async {
    try {
      await _db
          .collection("users")
          .doc(user.uid)
          .collection("run_${user.numberOfRuns.toString()}")
          .doc('step_$noStep')
          .set({"data": positions});
    } on FirebaseException {
      print("A picat si nu e bine ca nu a mers scrioerea");
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
}
