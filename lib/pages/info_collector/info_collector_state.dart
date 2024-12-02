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
  final bool stopFromClicking;
  final String description;

  InfoCollectorInitialState({
    required this.description,
    required this.email,
    required this.password,
    required this.sex,
    required this.age,
    required this.firstName,
    required this.lastName,
    required this.failure,
    required this.stopFromClicking,
  });

  InfoCollectorInitialState copyWith({
    String? email,
    String? password,
    Sex? sex,
    int? age,
    String? firstName,
    String? lastName,
    CreateUserFailure? failure,
    bool? stopFromClicking,
    String? description,
  }) {
    return InfoCollectorInitialState(
      email: email ?? this.email,
      password: password ?? this.password,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      failure: failure ?? this.failure,
      stopFromClicking: stopFromClicking ?? this.stopFromClicking,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props =>
      [email, firstName, lastName, age, sex, failure, stopFromClicking, description];
}

class InfoCollectorSuccessState extends InfoCollectorState {
  final User user;

  InfoCollectorSuccessState({required this.user});
  @override
  List<Object?> get props => [user];
}
