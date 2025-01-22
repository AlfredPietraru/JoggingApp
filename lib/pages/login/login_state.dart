import 'package:equatable/equatable.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/auth/user.dart';

sealed class LoginState extends Equatable {}

class LoginStateInitial extends LoginState {
  final LoginFailure failure;
  final String email;
  final String password;
  final bool requestLoading;

  LoginStateInitial(
      {required this.requestLoading,
      required this.email,
      required this.password,
      required this.failure});

  LoginStateInitial copyWith({
    String? email,
    String? password,
    LoginFailure? failure,
    bool? requestLoading,
  }) {
    return LoginStateInitial(
      email: email ?? this.email,
      password: password ?? this.password,
      failure: failure ?? this.failure,
      requestLoading: requestLoading ?? this.requestLoading,
    );
  }

  @override
  List<Object?> get props => [email, password, failure, requestLoading];
}

class LoginSuccessful extends LoginState {
  final User user;

  LoginSuccessful({required this.user});

  @override
  List<Object?> get props => [user];
}
