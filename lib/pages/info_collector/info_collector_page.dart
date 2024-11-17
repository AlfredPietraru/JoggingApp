import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/core/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/custom_button.dart';
import 'package:jogging/core/custom_textform.dart';
import 'package:jogging/gen/assets.gen.dart';
import 'package:jogging/pages/info_collector/info_collector_cubit.dart';
import 'package:jogging/pages/info_collector/info_collector_state.dart';
import 'package:jogging/pages/map/map_page.dart';
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
              context.read<AppCubit>().setUser(state.user);
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
      final oldState = state;
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.6), BlendMode.colorBurn),
              image: AssetImage(Assets.backgrounds.avenue815297640.path),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: AppPadding.page,
            child: ListView(
              children: [
                const Align(
                    alignment: Alignment.topLeft, child: MyBackButton()),
                const SizedBox(height: 30),
                Text(
                  'Tell us your first name:',
                  style: AppTextStyle.body.copyWith(fontSize: 30),
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextForm(
                  controller: firstNameController,
                  labelText: 'First name',
                  onChanged: context.read<InfoCollectorCubit>().changeFirstName,
                ),
                Text(
                  switch ((state as InfoCollectorInitialState).failure) {
                    CreateUserFailure.invalidFirstName => "Invalid firstname",
                    _ => "",
                  },
                  style: AppTextStyle.alert.copyWith(color: Colors.red),
                ),
                Text(
                  'And your last name:',
                  style: AppTextStyle.body.copyWith(fontSize: 30),
                ),
                CustomTextForm(
                  controller: lastNameController,
                  labelText: 'Enter your last name',
                  onChanged: context.read<InfoCollectorCubit>().changeLastName,
                ),
                Text(
                  switch (state.failure) {
                    CreateUserFailure.invalidLastName => "Invalid lastname",
                    _ => "",
                  },
                  style: AppTextStyle.alert.copyWith(color: Colors.red),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Choose your age:',
                  style: AppTextStyle.body.copyWith(fontSize: 30),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: NumberPicker(
                    itemWidth: MediaQuery.of(context).size.width / 6,
                    itemCount: 5,
                    axis: Axis.horizontal,
                    selectedTextStyle: AppTextStyle.body
                        .copyWith(fontSize: 30, color: Colors.red),
                    textStyle: AppTextStyle.body.copyWith(fontSize: 30),
                    value: state.age,
                    minValue: 18,
                    maxValue: 100,
                    onChanged:
                        context.read<InfoCollectorCubit>().changeAgeValue,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose your gender:',
                    style: AppTextStyle.body.copyWith(fontSize: 30),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xxxlg),
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(20),
                    style: AppTextStyle.body.copyWith(fontSize: 30),
                    alignment: Alignment.center,
                    value: (context.read<InfoCollectorCubit>().state
                            as InfoCollectorInitialState)
                        .sex
                        .toName(),
                    onChanged:
                        context.read<InfoCollectorCubit>().changeSexValue,
                    items: [
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        value: Sex.female.toName(),
                        child: Text(Sex.female.toName()),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        value: Sex.male.toName(),
                        child: Text(Sex.male.toName()),
                      ),
                      DropdownMenuItem(
                        alignment: Alignment.center,
                        value: Sex.other.toName(),
                        child: Text(Sex.other.toName()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    stopFromClicking: switch (oldState) {
                      InfoCollectorInitialState() => oldState.stopFromClicking,
                      _ => false,
                    },
                    onPressed: context.read<InfoCollectorCubit>().createUser,
                    label: "Send profile info",
                  ),
                ),
                Text(
                  switch (state.failure) {
                    CreateUserFailure.emailInUseFailure =>
                      "An account with this email already exists",
                    CreateUserFailure.noInternetConnection =>
                      "No internet connection.",
                    CreateUserFailure.unknownFailure =>
                      "Unknown failure occured",
                    _ => "",
                  },
                  style: AppTextStyle.alert.copyWith(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
