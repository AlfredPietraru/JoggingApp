// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:equatable/equatable.dart';

/// local user of the app
final class User extends Equatable {
  const User({
    required this.description,
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.sex,
    required this.numberOfRuns,
    required this.friendList,
  });

  factory User.getInitialUser(String email, String uid) {
    return User(
        friendList: [],
        description: "",
        numberOfRuns: 0,
        uid: uid,
        email: email,
        firstName: "",
        lastName: "",
        age: 0,
        sex: Sex.other);
  }

  factory User.fromSharedPreferences(String values) {
    final userData = jsonDecode(values) as Map<String, dynamic>;
    return User(
      friendList: userData['friendList'],
      description: userData['description'],
      uid: userData['uid'],
      email: userData['email'],
      firstName: userData['firstName'],
      lastName: userData['lastName'],
      age: userData['age'],
      sex: Sex.fromName(userData['sex']),
      numberOfRuns: userData['numberOfRuns'],
    );
  }

  // String toSharedPreferences() {
  //   return jsonEncode({
  //     'friendList': friendList,
  //     'description': description,
  //     'uid': uid,
  //     'email': email,
  //     'firstName': firstName,
  //     'lastName': lastName,
  //     'sex': sex.toName(),
  //     'age': age,
  //     'numberOfRuns': numberOfRuns,
  //   });
  // }

  /// Creates a user from json
  factory User.fromJson(
      {required Map<String, dynamic> json, required String id}) {
    return User(
      friendList: List<String>.from(json['friendList'] as List),
      uid: id,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: json['age'] as int,
      sex: Sex.fromName(
        json['sex'] as String,
      ),
      numberOfRuns: json['numberOfRuns'] as int,
      description: json['description'] as String,
    );
  }

  /// The box for local users
  final List<String> friendList;
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final int age;
  final Sex sex;
  final int numberOfRuns;
  final String description;

  User copyWith({
    String? email,
    String? firstName,
    String? lastName,
    int? age,
    Sex? sex,
    String? uid,
    int? numberOfRuns,
    String? description,
    List<String>? friendList,
  }) {
    return User(
      friendList: friendList ?? this.friendList,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      numberOfRuns: numberOfRuns ?? this.numberOfRuns,
      description: description ?? this.description,
    );
  }

  /// Creates a user from json
  Map<String, dynamic> toJson() {
    /// creates a json with all the fields
    return {
      'friendList': friendList,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'sex': sex.toName(),
      'age': age,
      'numberOfRuns': numberOfRuns,
      'description': description,
      "pendingList": [],
    };
  }

  @override
  List<Object?> get props => [
        email,
        firstName,
        lastName,
        sex,
        age,
        description,
        numberOfRuns,
        friendList,
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
