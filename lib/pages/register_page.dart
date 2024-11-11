import 'package:flutter/material.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/pages/info_collector/info_collector_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const RegisterPage());

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _invalidEmail = false;
  bool _invalidPassword = false;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back", style: TextStyle(fontSize: 30)),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Register:",
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your email',
              ),
              onChanged: (email) {
                setState(() {
                  _invalidEmail = !_isEmailValid(email);
                });
              },
            ),
            _invalidEmail
                ? Text('Invalid email format',
                    style: AppTextStyle.alert.copyWith(color: Colors.red))
                : const SizedBox(height: 0),
            const SizedBox(height: 30),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your passsword'),
              onChanged: (password) {
                setState(() {
                  _invalidPassword = !_isPasswordValid(password);
                });
              },
            ),
            _invalidPassword
                ? Text('Invalid password, should be more complex',
                    style: AppTextStyle.alert.copyWith(color: Colors.red))
                : const SizedBox(height: 0),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (!_invalidEmail && !_invalidPassword) {
                  Navigator.push(
                      context,
                      InfoCollector.page(
                          emailController.text, passwordController.text));
                }
              },
              child: const Text("Register me"),
            ),
          ],
        ),
      ),
    );
  }
}
