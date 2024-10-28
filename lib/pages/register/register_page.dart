import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/constants.dart';
import 'package:jogging/pages/info_collector/info_collector_page.dart';
import 'package:jogging/pages/register/register_cubit.dart';
import 'package:jogging/pages/register/register_state.dart';
import 'package:jogging/auth/repository.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const RegisterPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RegisterCubit(client: context.read<UserRepository>()),
      child: Builder(builder: (context) {
        return BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccesful) Navigator.push(context, InfoCollector.page());
          },
          child: const _RegisterPage(),
        );
      }),
    );
  }
}

class _RegisterPage extends StatefulWidget {
  const _RegisterPage();

  @override
  State<_RegisterPage> createState() => __RegisterPageState();
}

class __RegisterPageState extends State<_RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RegisterCubit>().state;
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
            ),
            switch (state) {
              RegisterInvalidEmailFailure() => Text('Invalid email format',
                  style: AppTextStyle.alert.copyWith(color: Colors.red)),
              RegisterEmailInUseFailure() => Text(
                  'There is an account which already has this email.',
                  style: AppTextStyle.alert.copyWith(color: Colors.red)),
              _ => const SizedBox(height: 0),
            },
            const SizedBox(height: 30),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your passsword',
              ),
            ),
            state is RegisterWeakPasswordFailure
                ? Text('Password is too short',
                    style: AppTextStyle.alert.copyWith(color: Colors.red))
                : const SizedBox(height: 0),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.read<RegisterCubit>().userWasCreated(
                    emailController.text, passwordController.text);
              },
              child: const Text("Register me"),
            ),
            state is RegisterUnknownFailure
                ? Text("Database unreachable",
                    style: AppTextStyle.alert.copyWith(color: Colors.red))
                : const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
