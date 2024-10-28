import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/constants.dart';
import 'package:jogging/pages/info_collector/info_collector_cubit.dart';
import 'package:jogging/pages/info_collector/info_collector_state.dart';
import 'package:jogging/pages/map_page.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/auth/repository.dart';
import 'package:numberpicker/numberpicker.dart';

class InfoCollector extends StatelessWidget {
  const InfoCollector({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const InfoCollector());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InfoCollectorCubit(userRepository: context.read<UserRepository>()),
      child: const _InfoCollector(),
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
  int _currentValue = 18;

  @override
  void dispose() {
    lastNameController.dispose();
    firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoCollectorCubit, InfoCollectorState>(
        builder: (context, state) {
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
              ),
              state is InfoCollectorWrongFirstNameState
                  ? Text(
                      "First name is not valid",
                      style: AppTextStyle.alert.copyWith(color: Colors.red),
                    )
                  : const SizedBox(height: 0),
              const SizedBox(height: 30),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your last name',
                ),
              ),
              state is InfoCollectorWrongFirstNameState
                  ? Text(
                      "Last name is not valid",
                      style: AppTextStyle.alert.copyWith(color: Colors.red),
                    )
                  : const SizedBox(height: 0),
              const SizedBox(height: 30),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Choose your age:')),
              const SizedBox(height: 20),
              NumberPicker(
                value: _currentValue,
                minValue: 18,
                maxValue: 100,
                onChanged: (value) => setState(() => _currentValue = value),
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Choose your gender:')),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: decision,
                onChanged: (String? result) {
                  if (result is String) {
                    setState(() {
                      decision = result;
                    });
                  }
                },
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
                onPressed: () async {
                  final result = await context
                      .read<InfoCollectorCubit>()
                      .completeUserInfo(
                          firstNameController.text,
                          lastNameController.text,
                          Sex.fromName(decision),
                          _currentValue);
                  if (result && context.mounted) {
                    Navigator.push(context, MapPage.page());
                  }
                },
                child: Text(
                  "Send profile info",
                  style: AppTextStyle.button,
                ),
              ),
              state is InfoCollectorNoInternetState
                  ? Text(
                      "No internet connection, try again later.",
                      style: AppTextStyle.alert.copyWith(color: Colors.red),
                    )
                  : const SizedBox(height: 0),
            ],
          ),
        ),
      );
    });
  }
}
