import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/core/widgets/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/widgets/custom_button.dart';
import 'package:jogging/core/widgets/custom_textform.dart';
import 'package:jogging/pages/login/login_cubit.dart';
import 'package:jogging/pages/login/login_state.dart';
import 'package:jogging/pages/map/map_page.dart';
import 'package:jogging/auth/repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const LoginPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(userRepository: context.read<UserRepository>()),
      child: Builder(builder: (context) {
        return BlocListener<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccessful) {
              Navigator.push(context, MapPage.page());
            }
          },
          child: const _LoginPage(),
        );
      }),
    );
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage();

  @override
  State<_LoginPage> createState() => __LoginPageState();
}

class __LoginPageState extends State<_LoginPage> {
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        return previous is LoginStateInitial && current is LoginStateInitial;
      },
      builder: (context, currentState) {
        final state = (currentState as LoginStateInitial);
        return Scaffold(
          body: Padding(
            padding: AppPadding.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyBackButton(),
                const SizedBox(height: AppSpacing.xlg),
                Text(
                  'We are glad to see you back!',
                  style: AppTextStyle.body.copyWith(fontSize: 25),
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomTextForm(
                  controller: emailController,
                  onChanged: context.read<LoginCubit>().adaptEmail,
                  labelText: 'Enter your email',
                ),
                Text(
                    switch (state.failure) {
                      LoginFailure.wrongCredentials =>
                        "Wrong email or password.",
                      LoginFailure.invalidEmail =>
                        'The email does not have the right format.',
                      _ => "",
                    },
                    style: AppTextStyle.alert),
                CustomTextForm(
                  controller: passwordController,
                  onChanged: context.read<LoginCubit>().adaptPassword,
                  labelText: 'Enter your passsword',
                ),
                Text(
                    switch (state.failure) {
                      LoginFailure.wrongCredentials =>
                        'Wrong email or password.',
                      LoginFailure.invalidPassword =>
                        'Password does not have the right format.',
                      _ => "",
                    },
                    style: AppTextStyle.alert),
                const SizedBox(height: 30),
                state.requestLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox(height: 0),
                const SizedBox(height: AppSpacing.md),
                CustomButton(
                  stopFromClicking: false,
                  onPressed: state.requestLoading
                      ? () {}
                      : context.read<LoginCubit>().loginUser,
                  label: "Login into account",
                ),
                Text(
                  switch (state.failure) {
                    LoginFailure.noInternetConnection =>
                      "No Internet connection, try again later",
                    _ => "",
                  },
                  style: AppTextStyle.alert,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
