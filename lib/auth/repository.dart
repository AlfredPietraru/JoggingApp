import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/auth/run_session.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/friend_request.dart';
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
  final _storage = FirebaseStorage.instance.ref();

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
        friendList: const [],
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

      return Right(User.fromJson(json: userValues.data()!, id: uid));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapLoginFailures(e.code));
    }
  }

  Future<List<String>> getLimitedUserIds(int limit) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot snapshot = await usersCollection.limit(limit).get();
      List<String> userIds = snapshot.docs.map((doc) => doc.id).toList();
      return userIds;
    } catch (e) {
      print("Error fetching user IDs with limit: $e");
      return [];
    }
  }



  Future<List<User>> getMultipleUsers(List<String> uids) async {
    if (uids.isEmpty) return [];
    final snapshot = await _db
        .collection("users")
        .where(FieldPath.documentId, whereIn: uids)
        .get();
    return snapshot.docs
        .map((doc) => User.fromJson(json: doc.data(), id: doc.id))
        .toList();
  }

  Future<void> deleteFriendRequest(FriendRequest request) async {
    try {
      await _db
          .collection("friend_requests")
          .doc(request.receiverId)
          .collection("requests")
          .doc(request.senderId)
          .delete();
    } on FirebaseException {
      print("nu a gasit friend request-pt a-l sterge");
    }
    try {
      await _db.collection("users").doc(request.senderId).update({
        "pendingList": FieldValue.arrayRemove([request.receiverId])
      });
    } on FirebaseException {
      print("nu a gasit elementul in pending list");
    }
  }

  // Future<List<User>> getNonRepeatingUsers(List<User> users, int limit) async {
  //   final List<String> userIds = List.from(users.map((u) => u.uid));
  //   final snapshot = await _db
  //       .collection("users")
  //       .where(FieldPath.documentId, whereNotIn: userIds)
  //       .limit(limit)
  //       .get();
  //   return List.from(snapshot.docs
  //       .map((doc) => User.fromJson(json: doc.data(), id: doc.id)));
  // }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendTokenToDatabase(User user, String token) async {
    try {
      await _db
          .collection("users")
          .doc(user.uid)
          .set({"notificationToken": token});
    } on FirebaseException {
      print("Nu s-a putut trimite token-ul la baza de date");
    }
  }

  Future<void> sendImageToDatabase(String path) async {}

  Future<Uint8List?> getProfilePicture(String path) async {
    final imageRef = _storage.child(path);
    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return null;
      return imageBytes;
    } catch (e) {
      print(
          "Profile picture not found. Or there is no connection to the internet");
    }
    return null;
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

  Future<RunSession?> returnRunData(String uid, String runName) async {
    try {
      final runCollection = await _db
          .collection("users")
          .doc(uid)
          .collection(runName)
          .doc("run_info")
          .get();
      Map<String, dynamic>? mapValues = runCollection.data();
      if (mapValues == null) {
        print("nu exista continut cu numele $runName");
        return null;
      }
      return RunSession.fromJson(mapValues);
    } on FirebaseException catch (e) {
      print(
          "Nu s-a gasit un run cu acest nume sau nu exista acces la internet");
      return null;
    }
  }

  Future<void> writeRunData(
      String uid, RunSession runSession, int index) async {
    try {
      await _db
          .collection("users")
          .doc(uid)
          .collection("run_$index")
          .doc('run_info')
          .set(runSession.convertToDatabaseOut());
      await _db.collection("users").doc(uid).update({
        "numberOfRuns": index,
      });
    } on FirebaseException {
      print("A picat si nu e bine ca nu a mers scrierea");
    }
  }

  Future<CreateUserFailure?> addUserToDatabase({required User user}) async {
    final canSendNotificationWithToken =
        await prefs.containsKey("notificationToken");
    if (canSendNotificationWithToken) {
      String? token = await prefs.getString("notificationToken");
      if (token != null) {
        sendTokenToDatabase(user, token);
      }
    }
    try {
      await _db.collection("users").doc(user.uid).set(user.toJson());
      return null;
    } on FirebaseException {
      return CreateUserFailure.unknownFailure;
    }
  }

  Future<User?> getUserFromDatabase(String id) async {
    final userValues = await _db.collection("users").doc(id).get();
    if (userValues.data() == null || userValues.data()!.isEmpty) {
      return null;
    }
    return User.fromJson(json: userValues.data()!, id: id);
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
    } on FirebaseException {
      print("nu este internet");
    }
  }

  Future<void> sendFriendRequest(FriendRequest request) async {
    try {
      await _db
          .collection("friend_requests")
          .doc(request.receiverId)
          .collection("requests")
          .doc(request.senderId)
          .set(request.toJson());
      await _db.collection("users").doc(request.senderId).update({
        "pendingList": FieldValue.arrayUnion([request.receiverId])
      });
    } on FirebaseException {
      print("nu a mers de trimis request-ul");
    }
  }

  Future<FriendRequest?> getFriendRequest(
      String receiverId, String senderId) async {
    final currentData = await _db
        .collection("friend_requests")
        .doc(receiverId)
        .collection("requests")
        .doc(senderId)
        .get();
    if (currentData.data() == null) return null;
    return FriendRequest.fromJson(currentData.data()!);
  }

  Future<List<FriendRequest>> getSentFriendRequests(String uid) async {
    List<String> usersWhoReceivedFriendRequest = [];
    try {
      await _db.collection("users").doc(uid).get().then((data) {
        usersWhoReceivedFriendRequest = List<String>.from(data['pendingList']);
      });
      if (usersWhoReceivedFriendRequest == []) return [];
      List<FriendRequest> outputList = [];
      for (int i = 0; i < usersWhoReceivedFriendRequest.length; i++) {
        final friendRequest =
            await getFriendRequest(usersWhoReceivedFriendRequest[i], uid);
        if (friendRequest == null) continue;
        outputList.add(friendRequest);
      }
      return outputList;
    } on FirebaseException {
      print("ceva nu merge");
    }
    return [];
  }

  Future<List<FriendRequest>> checkReceivedFriendRequests(String uid) async {
    try {
      final snapshot = await _db
          .collection("friend_requests")
          .doc(uid)
          .collection("requests")
          .get();
      return List.from(
          snapshot.docs.map((doc) => FriendRequest.fromJson(doc.data())));
    } on FirebaseException catch (e) {
      print(e.code);
      return [];
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
