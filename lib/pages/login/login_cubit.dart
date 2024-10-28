import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/pages/login/login_state.dart';
import 'package:jogging/auth/repository.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.userRepository})
      : super(LoginStateInitial(
          failure: LoginFailure.noFailureAtAll,
          password: '',
          email: '',
        ));
  final UserRepository userRepository;

  void adaptEmail(String newEmail) {
    emit((state as LoginStateInitial)
        .copyWith(email: newEmail, failure: LoginFailure.noFailureAtAll));
  }

  void adaptPassword(String newPassword) {
    emit((state as LoginStateInitial)
        .copyWith(password: newPassword, failure: LoginFailure.noFailureAtAll));
  }

  Future<void> loginUser() async {
    final oldState = state as LoginStateInitial;
    if (!_isEmailValid()) {
      emit(oldState.copyWith(failure: LoginFailure.invalidEmail));
      return;
    }

    if (!_isPasswordValid()) {
      emit(oldState.copyWith(failure: LoginFailure.invalidPassword));
      return;
    }

    final failure = await userRepository.login(
        email: oldState.email, password: oldState.password);
    if (failure == null) {
      emit(LoginSuccessful());
      return;
    }
    emit(oldState.copyWith(failure: failure));
  }

  bool _isEmailValid() {
    final oldState = state as LoginStateInitial;
    if (oldState.email == "") {
      return false;
    }
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    return regex.hasMatch(oldState.email);
  }

  bool _isPasswordValid() {
    final oldState = state as LoginStateInitial;
    return oldState.password.length > 6;
  }
}
