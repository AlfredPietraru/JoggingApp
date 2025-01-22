import 'package:flutter/material.dart';
import 'package:jogging/core/widgets/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/widgets/custom_button.dart';
import 'package:jogging/core/widgets/custom_textform.dart';
import 'package:jogging/gen/assets.gen.dart';
import 'package:jogging/pages/info_collector/info_collector_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const RegisterPage());

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> widthAnimation;
  late Animation<double> heightAnimation;

  bool _invalidEmail = false;
  bool _invalidPassword = false;
  bool _addRestOfInfo = false;

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
    animationController = AnimationController(
      duration: const Duration(seconds: 1, milliseconds: 500),
      vsync: this,
    );
    widthAnimation =
        Tween<double>(begin: 250.0, end: 300.0).animate(animationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _addRestOfInfo = true;
              });
            }
          });
    heightAnimation =
        Tween<double>(begin: 70, end: 250.0).animate(animationController);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.6), BlendMode.colorBurn),
            image: AssetImage(Assets.backgrounds.registerBackground.path),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: AppPadding.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: MyBackButton(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                "Register:",
                style: AppTextStyle.headline2.copyWith(fontSize: 40),
              ),
              const SizedBox(height: 20),
              CustomTextForm(
                controller: emailController,
                onChanged: (email) {
                  setState(() {
                    _invalidEmail = !_isEmailValid(email);
                  });
                },
                labelText: 'Enter your email',
              ),
              _invalidEmail
                  ? Text(
                      'Invalid email format',
                      style: AppTextStyle.alert.copyWith(),
                    )
                  : const SizedBox(height: 0),
              const SizedBox(height: AppSpacing.xlg),
              CustomTextForm(
                controller: passwordController,
                onChanged: (password) {
                  setState(() {
                    _invalidPassword = !_isPasswordValid(password);
                  });
                },
                labelText: 'Enter your passsword',
              ),
              _invalidPassword
                  ? Text('Invalid password, should be more complex',
                      style: AppTextStyle.alert)
                  : const SizedBox(height: 0),
              const SizedBox(height: 30),
              CustomButton(
                stopFromClicking: false,
                onPressed: () {
                  if (!_invalidEmail && !_invalidPassword) {
                    Navigator.push(
                        context,
                        InfoCollector.page(
                            emailController.text, passwordController.text));
                  }
                },
                label: 'Register me',
              ),
              const SizedBox(height: AppSpacing.lg),
              InkWell(
                onTap: () {
                  setState(() {
                    animationController.forward();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.buttonInterior,
                    borderRadius: BorderRadius.circular(AppSpacing.lg),
                    border:
                        Border.all(color: AppColors.pakistanGreen, width: 3),
                  ),
                  alignment: Alignment.topLeft,
                  width: widthAnimation.value,
                  height: heightAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About our mission',
                          style: AppTextStyle.headline1.copyWith(
                            color: AppColors.textColorBrown,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        _addRestOfInfo
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppPadding.unit,
                                    vertical: AppSpacing.sm),
                                child: Center(
                                  child: Text(
                                    'We blend together technology and sport, and with YOUR help, we can find the balance between them. Let\'s encourage a healthy lifestyle!',
                                    style: AppTextStyle.body.copyWith(
                                      color: const Color.fromARGB(
                                          255, 112, 69, 25),
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : const SizedBox(height: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
