import 'package:flutter/material.dart';
import 'package:jogging/pages/login/login_page.dart';
import 'package:jogging/pages/register_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const LandingPage());

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, RegisterPage.page());
                },
                child: const Text('Register', style: TextStyle(fontSize: 30))),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, LoginPage.page());
                },
                child: const Text('Login', style: TextStyle(fontSize: 30))),
          ],
        ),
      ),
    );
  }
}
