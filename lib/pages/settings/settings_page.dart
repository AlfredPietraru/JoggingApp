import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
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
        user: context.read<AppCubit>().user!,
      ),
      child: Builder(builder: (context) {
        return const _SettingsPage();
      }),
    );
  }
}

class _SettingsPage extends StatefulWidget {
  const _SettingsPage({super.key});
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
        final oldState = state as SettingsInitial;
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
                                  age: oldState.age,
                                  firstName: oldState.firstName,
                                  lastName: oldState.lastName,
                                  sex: oldState.sex,
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
                    context.read<AppCubit>().user!.email,
                    style: AppTextStyle.body.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(),
                  EditableZone(
                    label: "First Name",
                    value: oldState.firstName,
                    onPressedEditButton:
                        context.read<SettingsCubit>().toggleEditFirstName,
                    showEditingWindow: oldState.editFirstName,
                    textController: firstNameController,
                    onChanged: context.read<SettingsCubit>().changeFirstName,
                  ),
                  const Divider(),
                  EditableZone(
                    label: "Last Name",
                    value: oldState.lastName,
                    onPressedEditButton:
                        context.read<SettingsCubit>().toggleEditLastName,
                    showEditingWindow: oldState.editLastName,
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
                          oldState.editSex
                              ? DropdownButton<String>(
                                  value: oldState.sex.toName(),
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
                                  oldState.sex.toName(),
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
                          oldState.editAge
                              ? NumberPicker(
                                  value: oldState.age,
                                  minValue: 18,
                                  maxValue: 100,
                                  onChanged:
                                      context.read<SettingsCubit>().changeAge,
                                )
                              : Text(
                                  oldState.age.toString(),
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
                      style: AppTextStyle.body),
                  const SizedBox(height: AppSpacing.md),
                  _DangerousButton(
                    onPressed: () {},
                    text: "Change password",
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Want to switch account?', style: AppTextStyle.body),
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
                ? TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: value,
                    ),
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
        style: AppTextStyle.headline1.copyWith(color: Colors.red),
      ),
      content:
          Text('Are you sure you want to proceed', style: AppTextStyle.alert),
      elevation: 20,
      backgroundColor: Colors.blue.shade500,
      actions: [
        TextButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () {
            context.read<AppCubit>().deleteUserFromMemory();
            Navigator.of(context).popUntil((Route<dynamic> route) => false);
            Navigator.push(context, LandingPage.page());
          },
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
        style: AppTextStyle.button.copyWith(color: Colors.green.shade800),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonInterior,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
