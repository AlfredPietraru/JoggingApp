import 'package:jogging/auth/client.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/auth/user.dart';

class UserRepository {
  UserRepository({required this.authenticationClient});

  bool userInserted = false;
  late User user;
  final AuthenticationClient authenticationClient;

  Future<CreateUserFailure?> createAccount({
    required String email,
    required String password,
  }) async {
    final result = await authenticationClient.createAccount(
      email: email,
      password: password,
    );
    return result.fold((l) => l, (r) {
      user = User.getInitialUser(email, r);
      return null;
    });
  }

  Future<CreateUserFailure?> createUser({
    required String firstName,
    required String lastName,
    required int age,
    required Sex sex,
  }) async {
    user = user.copyWith(
      age: age,
      sex: sex,
      lastName: lastName,
      firstName: firstName,
    );
    userInserted = true;
    return await authenticationClient.addUserToDatabase(user: user);
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
