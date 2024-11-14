import 'package:dartz/dartz.dart';
import 'package:jogging/auth/client.dart';
import 'package:jogging/auth/failures.dart';
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
        _writeUserToMemory(r);
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

  Future<void> writePositionsToDatabase(String positionInfo, User user) async {
    authenticationClient.writePositionsToDatabase(positions: positionInfo, user: user);
  }

  User? getUserFromMemory() {
    final int? age = prefs.getInt('age');
    if (age == null) return null;
    final String? email = prefs.getString('email');
    if (email == null) return null;
    final String? firstName = prefs.getString('firstName');
    if (firstName == null) return null;
    final String? lastName = prefs.getString('lastName');
    if (lastName == null) return null;
    final String? uid = prefs.getString('uid');
    if (uid == null) return null;
    final String? sex = prefs.getString('sex');
    if (sex == null) return null;
    return User(
        age: age,
        uid: uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        sex: Sex.fromName(sex));
  }

  void deleteUserFromMemory() async {
    await prefs.remove('age');
    await prefs.remove('email');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('uid');
    await prefs.remove('sex');
  }

  void _writeUserToMemory(User user) async {
    await prefs.setString('email', user.email);
    await prefs.setString('firstName', user.firstName);
    await prefs.setString('lastName', user.lastName);
    await prefs.setInt('age', user.age);
    await prefs.setString('uid', user.uid);
    await prefs.setString('sex', user.sex.toString());
  }
}
