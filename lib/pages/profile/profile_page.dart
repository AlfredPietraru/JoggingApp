import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/widgets/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/widgets/editable_zone.dart';
import 'package:jogging/core/widgets/user_container.dart';
import 'package:jogging/gen/assets.gen.dart';
import 'package:jogging/pages/profile/profile_cubit.dart';
import 'package:jogging/pages/profile/profile_state.dart';
import 'package:numberpicker/numberpicker.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const ProfilePage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        user: context.read<AppCubit>().state.user!,
        userRepository: context.read<AppCubit>().userRepository,
      ),
      child: Builder(builder: (context) {
        return const _ProfilePage();
      }),
    );
  }
}

class _ProfilePage extends StatefulWidget {
  const _ProfilePage({super.key});

  @override
  State<_ProfilePage> createState() => __ProfilePageState();
}

class __ProfilePageState extends State<_ProfilePage> {
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
    final userState = context.select((AppCubit bloc) => bloc.state.user);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        return Scaffold(
          body: Padding(
            padding: AppPadding.page,
            child: ListView(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: MyBackButton(),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      context.read<ProfileCubit>().choosePhoto(userState!.uid);
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        Assets.images.noProfilePhoto.path,
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppPadding.unit),
                Text(
                  'Current user information:',
                  style: AppTextStyle.headline1,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text("Email:", style: AppTextStyle.body.copyWith(fontSize: 20)),
                Text(
                  context.read<AppCubit>().state.user!.email,
                  style: AppTextStyle.body.copyWith(fontSize: 20),
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(),
                EditableZone(
                  label: "First Name:",
                  value: profileState.firstName,
                  onPressedEditButton:
                      context.read<ProfileCubit>().toggleEditFirstName,
                  showEditingWindow: profileState.editFirstName,
                  textController: firstNameController,
                  onChanged: context.read<ProfileCubit>().changeFirstName,
                ),
                const Divider(),
                EditableZone(
                  label: "Last Name:",
                  value: profileState.lastName,
                  onPressedEditButton:
                      context.read<ProfileCubit>().toggleEditLastName,
                  showEditingWindow: profileState.editLastName,
                  textController: lastNameController,
                  onChanged: context.read<ProfileCubit>().changeLastName,
                ),
                const Divider(),
                Stack(
                  children: [
                    Align(
                      alignment: const Alignment(1, -1),
                      child: EditButton(
                          onPressed:
                              context.read<ProfileCubit>().toggleEditSex),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sex:',
                          style: AppTextStyle.body.copyWith(fontSize: 20),
                        ),
                        profileState.editSex
                            ? DropdownButton<String>(
                                value: profileState.sex.toName(),
                                onChanged:
                                    context.read<ProfileCubit>().changeSex,
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
                                profileState.sex.toName(),
                                style: AppTextStyle.body.copyWith(fontSize: 20),
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
                        onPressed: context.read<ProfileCubit>().toggleEditAge,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Age:',
                          style: AppTextStyle.body.copyWith(fontSize: 20),
                        ),
                        profileState.editAge
                            ? NumberPicker(
                                axis: Axis.horizontal,
                                selectedTextStyle: AppTextStyle.body
                                    .copyWith(fontSize: 20, color: Colors.red),
                                itemWidth:
                                    MediaQuery.of(context).size.width / 6,
                                textStyle:
                                    AppTextStyle.body.copyWith(fontSize: 20),
                                value: profileState.age,
                                minValue: 18,
                                maxValue: 100,
                                onChanged:
                                    context.read<ProfileCubit>().changeAge,
                              )
                            : Text(
                                profileState.age.toString(),
                                style: AppTextStyle.body.copyWith(fontSize: 20),
                              ),
                        const SizedBox(height: 20),
                        UserContainer(
                          user: userState!,
                          tapAdd: null,
                          tapDelete: null,
                          tapViewProfile: null,
                        ),
                        const SizedBox(height: 20),
                        if (context
                            .read<ProfileCubit>()
                            .shouldApplyChanges(userState))
                          ElevatedButton(
                            onPressed: () {
                              final newUser = context
                                  .read<ProfileCubit>()
                                  .updateUser(userState);
                              context.read<AppCubit>().changeUser(newUser);
                            },
                            child: const Text('Save changes'),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
