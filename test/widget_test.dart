// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/firebase_options.dart';

import 'package:jogging/main.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:disposebag/disposebag.dart' show DisposeBagConfigs;

import 'create_users/create_user_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DisposeBagConfigs.logger = null;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final userRepository = UserRepository(
    prefs: RxSharedPreferences(
      SharedPreferences.getInstance(),
      const RxSharedPreferencesDefaultLogger(),
    ),
  );
  final testCreateMoreUsers = TestCreateMoreUsers(
      fileName: "user_data.json", userRepository: userRepository);
  

}
