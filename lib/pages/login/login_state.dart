import 'package:equatable/equatable.dart';
import 'package:jogging/auth/failures.dart';

sealed class LoginState extends Equatable {}

class LoginStateInitial extends LoginState {
  final LoginFailure failure;
  final String email;
  final String password;

  LoginStateInitial(
      {required this.email, required this.password, required this.failure});

  LoginStateInitial copyWith({
    String? email,
    String? password,
    LoginFailure? failure,
  }) {
    return LoginStateInitial(
      email: email ?? this.email,
      password: password ?? this.password,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [email, password, failure];
}

class LoginSuccessful extends LoginState {
  @override
  List<Object?> get props => [];
}
