import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/custom_textform.dart';
import 'package:jogging/gen/assets.gen.dart';
import 'package:jogging/pages/landing_page.dart';
import 'package:jogging/pages/settings/settings_cubit.dart';
import 'package:numberpicker/numberpicker.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const SettingsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(
        user: context.read<AppCubit>().state.user!,
      ),
      child: Builder(builder: (context) {
        return const _SettingsPage();
      }),
    );
  }
}

class _SettingsPage extends StatefulWidget {
  const _SettingsPage();
  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: AppPadding.page,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md, horizontal: AppSpacing.md),
              child: ListView(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: MyBackButton(),
                  ),
                  context.read<SettingsCubit>().applyChanges()
                      ? ElevatedButton(
                          onPressed: () {
                            context.read<AppCubit>().changeUserInformation(
                                  age: state.age,
                                  firstName: state.firstName,
                                  lastName: state.lastName,
                                  sex: state.sex,
                                );
                          },
                          child: const Text('Save changes'),
                        )
                      : const SizedBox(height: 0),
                  const SizedBox(height: AppPadding.unit),
                  Text(
                    'Current user information:',
                    style: AppTextStyle.headline1,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text("Email:",
                      style: AppTextStyle.body.copyWith(fontSize: 20)),
                  Text(
                    context.read<AppCubit>().state.user!.email,
                    style: AppTextStyle.body.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(),
                  EditableZone(
                    label: "First Name:",
                    value: state.firstName,
                    onPressedEditButton:
                        context.read<SettingsCubit>().toggleEditFirstName,
                    showEditingWindow: state.editFirstName,
                    textController: firstNameController,
                    onChanged: context.read<SettingsCubit>().changeFirstName,
                  ),
                  const Divider(),
                  EditableZone(
                    label: "Last Name:",
                    value: state.lastName,
                    onPressedEditButton:
                        context.read<SettingsCubit>().toggleEditLastName,
                    showEditingWindow: state.editLastName,
                    textController: lastNameController,
                    onChanged: context.read<SettingsCubit>().changeLastName,
                  ),
                  const Divider(),
                  Stack(
                    children: [
                      Align(
                        alignment: const Alignment(1, -1),
                        child: EditButton(
                            onPressed:
                                context.read<SettingsCubit>().toggleEditSex),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sex:',
                            style: AppTextStyle.body.copyWith(fontSize: 20),
                          ),
                          state.editSex
                              ? DropdownButton<String>(
                                  value: state.sex.toName(),
                                  onChanged:
                                      context.read<SettingsCubit>().changeSex,
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
                                )
                              : Text(
                                  state.sex.toName(),
                                  style:
                                      AppTextStyle.body.copyWith(fontSize: 20),
                                ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  Stack(
                    children: [
                      Align(
                        alignment: const Alignment(1, -1),
                        child: EditButton(
                          onPressed:
                              context.read<SettingsCubit>().toggleEditAge,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age:',
                            style: AppTextStyle.body.copyWith(fontSize: 20),
                          ),
                          state.editAge
                              ? NumberPicker(
                                  axis: Axis.horizontal,
                                  selectedTextStyle: AppTextStyle.body.copyWith(
                                      fontSize: 20, color: Colors.red),
                                  itemWidth:
                                      MediaQuery.of(context).size.width / 6,
                                  textStyle:
                                      AppTextStyle.body.copyWith(fontSize: 20),
                                  value: state.age,
                                  minValue: 18,
                                  maxValue: 100,
                                  onChanged:
                                      context.read<SettingsCubit>().changeAge,
                                )
                              : Text(
                                  state.age.toString(),
                                  style:
                                      AppTextStyle.body.copyWith(fontSize: 20),
                                ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.danger,
                        width: 50,
                        height: 50,
                        colorFilter:
                            const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Danger zone:',
                        style:
                            AppTextStyle.headline1.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Sometimes, you should change me:',
                      style: AppTextStyle.body.copyWith(fontSize: 20)),
                  const SizedBox(height: AppSpacing.md),
                  _DangerousButton(
                    onPressed: () {},
                    text: "Change password",
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Want to switch account?',
                    style: AppTextStyle.body.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DangerousButton(
                    onPressed: () {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) =>
                              const LogOutAlertDialog());
                    },
                    text: "Log out",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class EditableZone extends StatelessWidget {
  final Function() onPressedEditButton;
  final Function(String) onChanged;
  final bool showEditingWindow;
  final String label;
  final String value;
  final TextEditingController textController;

  const EditableZone(
      {super.key,
      required this.onPressedEditButton,
      required this.showEditingWindow,
      required this.textController,
      required this.onChanged,
      required this.label,
      required this.value});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(1, -1),
          child: EditButton(
            onPressed: onPressedEditButton,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text(
              label,
              style: AppTextStyle.body.copyWith(fontSize: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            showEditingWindow
                ? CustomTextForm(
                    controller: textController,
                    labelText: value,
                    onChanged: onChanged,
                  )
                : Text(
                    value,
                    style: AppTextStyle.body.copyWith(fontSize: 20),
                  ),
          ],
        ),
      ],
    );
  }
}

class _DangerousButton extends StatelessWidget {
  const _DangerousButton({required this.text, required this.onPressed});
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md, horizontal: AppSpacing.lg),
          backgroundColor: Colors.yellow.shade500,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Colors.red, width: 3),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyle.button.copyWith(color: Colors.red, fontSize: 20),
        ),
      ),
    );
  }
}

class LogOutAlertDialog extends StatelessWidget {
  const LogOutAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Logging out?',
        style: AppTextStyle.headline1.copyWith(color: AppColors.textColorBrown),
      ),
      content: Text(
        'Are you sure you want to proceed?',
        style: AppTextStyle.alert.copyWith(color: AppColors.textColorBrown),
        textAlign: TextAlign.center,
      ),
      elevation: 20,
      backgroundColor: AppColors.buttonInterior,
      actionsPadding: const EdgeInsets.all(AppSpacing.xlg),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        SizedBox(
          width: 120,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.enabledFieldOrange,
              shadowColor: AppColors.costalBlue,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              side: const BorderSide(color: AppColors.eerieBlack, width: 2),
            ),
            child: Text(
              "No",
              style: AppTextStyle.alert.copyWith(
                color: AppColors.textColorBrown,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(
          width: 120,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.enabledFieldOrange,
              shadowColor: AppColors.costalBlue,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              side: const BorderSide(color: AppColors.eerieBlack, width: 2),
            ),
            child: Text(
              "Yes",
              style: AppTextStyle.alert.copyWith(
                color: AppColors.textColorBrown,
              ),
            ),
            onPressed: () {
              context.read<AppCubit>().deleteUserFromMemory();
              Navigator.of(context).popUntil((Route<dynamic> route) => false);
              Navigator.push(context, LandingPage.page());
            },
          ),
        ),
      ],
    );
  }
}

class EditButton extends StatelessWidget {
  const EditButton({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: SvgPicture.asset(
        Assets.icons.pencil,
      ),
      label: Text(
        'Edit',
        style: AppTextStyle.button.copyWith(color: AppColors.eerieBlack),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonInterior,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.eerieBlack, width: 2),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
