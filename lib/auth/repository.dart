import 'package:dartz/dartz.dart';
import 'package:jogging/auth/client.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/auth/user.dart';

class UserRepository {
  UserRepository({required this.authenticationClient});

  bool userInserted = false;
  late User user;
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
        user = r;
        return Right(r);
      },
    );
  }

  Future<LoginFailure?> login(
      {required String email, required String password}) async {
    final result = await authenticationClient.login(email, password);
    return result.fold((l) {
      return l;
    }, (r) {
      user = r;
      userInserted = true;
      return null;
    });
  }
}
