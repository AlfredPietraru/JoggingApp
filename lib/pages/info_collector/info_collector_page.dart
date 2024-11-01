import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/constants.dart';
import 'package:jogging/pages/info_collector/info_collector_cubit.dart';
import 'package:jogging/pages/info_collector/info_collector_state.dart';
import 'package:jogging/pages/map_page.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/auth/repository.dart';
import 'package:numberpicker/numberpicker.dart';

class InfoCollector extends StatelessWidget {
  const InfoCollector({super.key, required this.email, required this.password});
  final String email;
  final String password;
  static Route<void> page(String email, String password) =>
      MaterialPageRoute<void>(
          builder: (_) => InfoCollector(email: email, password: password));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InfoCollectorCubit(
          userRepository: context.read<UserRepository>(),
          email: email,
          password: password),
      child: Builder(builder: (context) {
        return BlocListener<InfoCollectorCubit, InfoCollectorState>(
          listener: (context, state) {
            if (state is InfoCollectorSuccessState) {
              Navigator.pushReplacement(context, MapPage.page());
            }
          },
          child: const _InfoCollector(),
        );
      }),
    );
  }
}

class _InfoCollector extends StatefulWidget {
  const _InfoCollector();

  @override
  State<_InfoCollector> createState() => __InfoCollectorState();
}

class __InfoCollectorState extends State<_InfoCollector> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String decision = Sex.male.toName();

  @override
  void dispose() {
    lastNameController.dispose();
    firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoCollectorCubit, InfoCollectorState>(
        buildWhen: (previous, current) {
      return (previous is InfoCollectorInitialState) &&
          (current is InfoCollectorInitialState);
    }, builder: (context, state) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back", style: TextStyle(fontSize: 30)),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your first name',
                ),
                onChanged: context.read<InfoCollectorCubit>().changeFirstName,
              ),
              Text(
                switch ((state as InfoCollectorInitialState).failure) {
                  CreateUserFailure.invalidFirstName => "Invalid firstname",
                  _ => "",
                },
                style: AppTextStyle.alert.copyWith(color: Colors.red),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your last name',
                ),
                onChanged: context.read<InfoCollectorCubit>().changeLastName,
              ),
              Text(
                switch (state.failure) {
                  CreateUserFailure.invalidLastName => "Invalid lastname",
                  _ => "",
                },
                style: AppTextStyle.alert.copyWith(color: Colors.red),
              ),
              const SizedBox(height: 30),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Choose your age:')),
              const SizedBox(height: 20),
              NumberPicker(
                value: state.age,
                minValue: 18,
                maxValue: 100,
                onChanged: context.read<InfoCollectorCubit>().changeAgeValue,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Choose your gender:')),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: (context.read<InfoCollectorCubit>().state
                        as InfoCollectorInitialState)
                    .sex
                    .toName(),
                onChanged: context.read<InfoCollectorCubit>().changeSexValue,
                items: [
                  DropdownMenuItem(
                    value: Sex.female.toName(),
                    child: Text(Sex.female.toName()),
                  ),
                  DropdownMenuItem(
                    value: Sex.male.toName(),
                    child: Text(Sex.male.toName()),
                  ),
                  DropdownMenuItem(
                    value: Sex.other.toName(),
                    child: Text(Sex.other.toName()),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: context.read<InfoCollectorCubit>().createUser,
                child: Text(
                  "Send profile info",
                  style: AppTextStyle.button,
                ),
              ),
              Text(
                switch (state.failure) {
                  CreateUserFailure.emailInUseFailure =>
                    "An account with this email already exists",
                  CreateUserFailure.noInternetConnection =>
                    "No internet connection.",
                  CreateUserFailure.unknownFailure => "Unknown failure occured",
                  _ => "",
                },
                style: AppTextStyle.alert.copyWith(color: Colors.red),
              ),
            ],
          ),
        ),
      );
    });
  }
}
