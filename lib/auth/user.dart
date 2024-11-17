// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';

/// local user of the app
final class User extends Equatable {
  const User({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.sex,
    required this.numberOfRuns,
    required this.runs,
  });

  factory User.getInitialUser(String email, String uid) {
    return User(
        runs: const [],
        numberOfRuns: 0,
        uid: uid,
        email: email,
        firstName: "",
        lastName: "",
        age: 0,
        sex: Sex.other);
  }

  /// Creates a user from json
  factory User.fromJson(Map<String, dynamic> json, {required String id}) {
    return User(
        uid: id,
        email: json['email'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        age: json['age'] as int,
        sex: Sex.fromName(
          json['sex'] as String,
        ),
        numberOfRuns: json['numberOfRuns'] as int,
        runs: json['runs']);
  }

  /// The box for local users
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final int age;
  final Sex sex;
  final int numberOfRuns;
  final List<String> runs;

  User copyWith({
    String? email,
    String? firstName,
    String? lastName,
    int? age,
    Sex? sex,
    String? uid,
    int? numberOfRuns,
    List<String>? runs,
  }) {
    return User(
      runs: runs ?? this.runs,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      numberOfRuns: numberOfRuns ?? this.numberOfRuns,
    );
  }

  /// Creates a user from json
  Map<String, dynamic> toJson() {
    /// creates a json with all the fields
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'sex': sex.toName(),
      'age': age,
      'runs': runs,
      'numberOfRuns': numberOfRuns,
    };
  }

  @override
  List<Object?> get props => [
        email,
        firstName,
        lastName,
        sex,
        age,
        numberOfRuns,
      ];
}

enum Sex {
  female,
  male,
  other;

  String toName() {
    if (this == Sex.female) {
      return 'female';
    }
    if (this == Sex.other) {
      return 'other';
    }
    return 'male';
  }

  static Sex fromName(String name) => switch (name) {
        'female' => Sex.female,
        'male' => Sex.male,
        'other' => Sex.other,
        _ => Sex.other,
      };
}
