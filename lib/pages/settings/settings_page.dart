import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jogging/core/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/gen/assets.gen.dart';
import 'package:jogging/pages/landing_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const SettingsPage());
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppPadding.page,
        child: ListView(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: MyBackButton(),
            ),
            const SizedBox(height: AppPadding.unit),
            Text(
              'Current user information:',
              style: AppTextStyle.headline1,
            ),
            const SizedBox(height: AppPadding.unit),
            _VerticalUserInfoDisplayer(
              canEdit: false,
              label: 'Email:',
              info: context.read<AppCubit>().user!.email,
            ),
            const Divider(),
            _VerticalUserInfoDisplayer(
              canEdit: true,
              label: 'Name:',
              info: context.read<AppCubit>().getFullUserName(),
            ),
            const Divider(),
            _HorizontalUserInfoDisplayer(
              info: 'Sex: ${context.read<AppCubit>().user!.sex.name}',
            ),
            const Divider(),
            _HorizontalUserInfoDisplayer(
              info: 'Age: ${context.read<AppCubit>().user!.age.toString()}',
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
                  style: AppTextStyle.headline1.copyWith(color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Sometimes, you should change me:', style: AppTextStyle.body),
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

class _HorizontalUserInfoDisplayer extends StatelessWidget {
  final String info;
  const _HorizontalUserInfoDisplayer({required this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md, horizontal: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            info,
            style: AppTextStyle.body.copyWith(fontSize: 20),
          ),
          const Spacer(),
          Align(
              alignment: const Alignment(1, -1),
              child: EditButton(onPressed: () {}))
        ],
      ),
    );
  }
}

class _VerticalUserInfoDisplayer extends StatelessWidget {
  final bool canEdit;
  final String label;
  final String info;
  const _VerticalUserInfoDisplayer(
      {required this.label, required this.info, required this.canEdit});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md, horizontal: AppSpacing.md),
      child: Stack(children: [
        canEdit
            ? Align(
                alignment: const Alignment(1, -1),
                child: EditButton(onPressed: () {}))
            : const SizedBox(height: 0),
        SizedBox(
          height: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Text(
                label,
                style: AppTextStyle.body.copyWith(fontSize: 20),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                info,
                style: AppTextStyle.body.copyWith(fontSize: 20),
              ),
            ],
          ),
        ),
      ]),
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
        backgroundColor: AppColors.buttonInteriorGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}
