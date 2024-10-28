import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/pages/register/register_state.dart';
import 'package:jogging/auth/repository.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.client}) : super(const RegisterInitial());

  final UserRepository client;

  Future<void> userWasCreated(String email, String password) async {
    if (!_isEmailValid(email)) {
      emit(const RegisterInvalidEmailFailure());
      return;
    }
    if (!_isPasswordValid(password)) {
      emit(const RegisterWeakPasswordFailure());
      return ;
    }
    final failure = await client.createAccount(email: email, password: password);
    if (failure == null) {
      emit(const RegisterSuccesful());
      return ;
    }
    switch (failure) {
      case CreateUserFailure.emailInUseFailure:
        emit(const RegisterEmailInUseFailure());
      case CreateUserFailure.operationNotPermittedFailure:
        emit(const RegisterOperationNotPermittedFailure());
      case CreateUserFailure.invalidEmailFailure:
        emit(const RegisterInvalidEmailFailure());
      case CreateUserFailure.weakPasswordFailure:
        emit(const RegisterWeakPasswordFailure());
      default:
        emit(const RegisterUnknownFailure());
    }
  }

  bool _isEmailValid(String email) {
    if (email == "") {
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
    return regex.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.length > 6;
  }
}
