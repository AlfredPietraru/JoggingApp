import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jogging/auth/client.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/auth/run_session.dart';
import 'package:jogging/auth/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  UserRepository({required this.authenticationClient, required this.prefs});

  final SharedPreferences prefs;
  final AuthenticationClient authenticationClient;

  Future<Either<CreateUserFailure, User>> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required int age,
    required Sex sex,
  }) async {
    final result = await authenticationClient.createUser(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        age: age,
        sex: sex);
    return result.fold(
      (l) {
        return Left(l);
      },
      (r) {
        writeUserToMemory(r);
        return Right(r);
      },
    );
  }

  Future<Either<LoginFailure, User>> login(
      {required String email, required String password}) async {
    final result = await authenticationClient.login(email, password);
    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }

  Future<RunSession?> returnRunData(User user, String runName) async {
    return await authenticationClient.returnRunData(user, runName);
  }

  Future<void> writePositionsToDatabase(RunSession runSession) async {
    authenticationClient.writePositionsToDatabase(runSession: runSession);
  }

  void updateUserInformation(User user) {
    authenticationClient.updateUserInformation(user);
  }

  User? getUserFromMemory() {
    String? data = prefs.getString('user_data');
    print(data);
    if (data == null) return null;
    Map<String, dynamic> userData = jsonDecode(data) as Map<String, dynamic>;
    return User(
      age: userData['age'],
      uid: userData['uid'],
      email: userData['email'],
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      sex: Sex.fromName(userData['sex']),
      numberOfRuns: userData['numberOfRuns'],
    );
  }

  void deleteUserFromMemory() async {
    await prefs.remove('user_data');
  }

  void writeUserToMemory(User user) async {
    await prefs.setString('user_data', user.toSharedPreferences());
  }
}
