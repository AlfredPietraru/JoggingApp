import 'package:equatable/equatable.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();

  @override
  List<Object?> get props => [];
}

class RegisterEmailInUseFailure extends RegisterState {
  const RegisterEmailInUseFailure();

  @override
  List<Object?> get props => [];
}

class RegisterInvalidEmailFailure extends RegisterState {
  const RegisterInvalidEmailFailure();

  @override
  List<Object?> get props => [];
}

class RegisterOperationNotPermittedFailure extends RegisterState {
  const RegisterOperationNotPermittedFailure();

  @override
  List<Object?> get props => [];
}

class RegisterWeakPasswordFailure extends RegisterState {
  const RegisterWeakPasswordFailure();

  @override
  List<Object?> get props => [];
}

class RegisterUnknownFailure extends RegisterState {
  const RegisterUnknownFailure();

  @override
  List<Object?> get props => [];
}

class RegisterSuccesful extends RegisterState {
  const RegisterSuccesful();

  @override
  List<Object?> get props => [];
}
