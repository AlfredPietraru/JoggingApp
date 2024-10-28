import 'package:equatable/equatable.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/auth/user.dart';

sealed class InfoCollectorState extends Equatable {}

class InfoCollectorInitialState extends InfoCollectorState {
  final CreateUserFailure failure;
  final String email;
  final String password;
  final Sex sex;
  final int age;
  final String firstName;
  final String lastName;
  InfoCollectorInitialState(
      {required this.email,
      required this.password,
      required this.sex,
      required this.age,
      required this.firstName,
      required this.lastName,
      required this.failure});

  InfoCollectorInitialState copyWith({
    String? email,
    String? password,
    Sex? sex,
    int? age,
    String? firstName,
    String? lastName,
    CreateUserFailure? failure,
  }) {
    return InfoCollectorInitialState(
      email: email ?? this.email,
      password: password ?? this.password,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [email, firstName, lastName, age, sex, failure];
}

class InfoCollectorSuccessState extends InfoCollectorState {
  @override
  List<Object?> get props => [];
}
