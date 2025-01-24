import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jogging/core/widgets/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/gen/assets.gen.dart';
import 'package:jogging/generated/l10n.dart';
import 'package:jogging/pages/landing_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const SettingsPage());
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: 40,
                height: 40,
                child: CheckboxListTile(
                  title: const Text("English"),
                  value:
                      context.read<AppCubit>().state.locale.countryCode == 'en',
                  onChanged: (bool? value) {
                    if (value == true) {
                      context
                          .read<AppCubit>()
                          .changeLanguage(const Locale('en'));
                    }
                  },
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: CheckboxListTile(
                  title: const Text("French"),
                  value:
                      context.read<AppCubit>().state.locale.countryCode == 'fr',
                  onChanged: (bool? value) {
                    if (value == true) {
                      context
                          .read<AppCubit>()
                          .changeLanguage(const Locale('fr'));
                    }
                  },
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: CheckboxListTile(
                  title: const Text("Spanish"),
                  value:
                      context.read<AppCubit>().state.locale.countryCode == 'es',
                  onChanged: (bool? value) {
                    if (value == true) {
                      context
                          .read<AppCubit>()
                          .changeLanguage(const Locale('es'));
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
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
                    S.of(context).dangerZone,
                    // 'Danger zone:',
                    style: AppTextStyle.headline1.copyWith(color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(S.of(context).changeMe,
                  // 'Sometimes, you should change me:',
                  style: AppTextStyle.body.copyWith(fontSize: 20)),
              const SizedBox(height: AppSpacing.md),
              _DangerousButton(
                onPressed: () {},
                text: S.of(context).changePassword,
                // "Change password",
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                S.of(context).switchAccount,
                // 'Want to switch account?',
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
                text: S.of(context).logOut,
                // "Log out",
              ),
            ],
          ),
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
              context.read<AppCubit>().userRepository.logOut();
              Navigator.pushReplacement(context, LandingPage.page());
            },
          ),
        ),
      ],
    );
  }
}
