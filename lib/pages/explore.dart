import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const Explore());

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AppCubit>().state.user!;
    return Scaffold(
      body: Padding(
        padding: AppPadding.page,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('go back'),
            ),
            _UserContainer(
              user: user,
              description:
                  "Buna, numele meu este Pietraru Alfred si folosesc Jogging Time. Imi place sa fac sport si sa calatoresc. Suna-ma daca vei vrea sa iesim la un moment dat.",
              tapAdd: () {},
              tapDelete: () {},
              tapViewProfile: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _UserContainer extends StatelessWidget {
  const _UserContainer({
    super.key,
    required this.user,
    required this.description,
    required this.tapAdd,
    required this.tapDelete,
    required this.tapViewProfile,
  });

  final User user;
  final String description;
  final Function() tapAdd;
  final Function() tapDelete;
  final Function() tapViewProfile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapViewProfile,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.eerieBlack, width: 2),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.eerieBlack, width: 2),
                  ),
                  child: const Center(
                      child: Text('Aici', textAlign: TextAlign.center)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "Stochirlea Ingrid Ana Maria de Rosa a la mires",
                        // "${user.firstName} ${user.lastName}",
                        style: AppTextStyle.body.copyWith(fontSize: 20),
                        maxLines: 2,
                      ),
                      Text(
                        "${user.age}, ${user.sex.toName()}",
                        style: AppTextStyle.body.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              children: [
                Wrap(children: [
                  Center(
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.body.copyWith(fontSize: 16),
                    ),
                  )
                ]),
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.enabledFieldOrange,
                  child: IconButton(
                      onPressed: tapAdd,
                      icon: const Icon(
                        Icons.plus_one,
                        color: AppColors.hunterGreen,
                      )),
                ),
                const SizedBox(width: AppSpacing.sm),
                CircleAvatar(
                  backgroundColor: AppColors.enabledFieldOrange,
                  child: IconButton(
                    onPressed: tapDelete,
                    icon: const Icon(
                      Icons.delete,
                      color: AppColors.hunterGreen,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
