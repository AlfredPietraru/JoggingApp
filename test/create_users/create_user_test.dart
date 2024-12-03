import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/user.dart';

class TestCreateMoreUsers {
  final String fileName;
  final UserRepository userRepository;
  TestCreateMoreUsers({required this.fileName, required this.userRepository});

  Future<List<String?>> verify() async {
    final String response = await rootBundle.loadString(fileName);
    List<dynamic> data = await json.decode(response);
    List<String?> result = [];
    for (int i = 0; i < data.length; i++) {
      final now = data[i];
      final current = await userRepository.createUser(
        email: now['email'],
        password: now['password'],
        firstName: now['firstName'],
        lastName: now['lastName'],
        age: now['age'],
        sex: now['sex'],
        description: now['description'],
      );
      current.fold((l) {
        result.add(null);
      }, (r) {
        result.add(r.uid);
      });
    }
    return result;
  }

  // void deleteUsersFromDatabase() {

  // }
}
