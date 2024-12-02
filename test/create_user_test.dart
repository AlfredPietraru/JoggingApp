import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jogging/auth/repository.dart';

class TestUserCreateDeleteLoginJson {
  final String fileName;
  final UserRepository userRepository;
  TestUserCreateDeleteLoginJson({required this.fileName, required this.userRepository}) {
    initialize();
  }

  void initialize() async {
    final String response = await rootBundle.loadString(fileName);
    List<dynamic> data = await json.decode(response);
    for (int i = 0; i < data.length; i++) {}
  }
}
