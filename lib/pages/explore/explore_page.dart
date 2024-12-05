import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/core/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/user_container.dart';
import 'package:jogging/pages/explore/explore_cubit.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const Explore());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreCubit(
        userRepository: context.read<AppCubit>().userRepository,
      ),
      child: Builder(builder: (context) {
        return const _Explore();
      }),
    );
  }
}

class _Explore extends StatefulWidget {
  const _Explore({super.key});

  @override
  State<_Explore> createState() => _ExploreState();
}

class _ExploreState extends State<_Explore> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exploreState = context.watch<ExploreCubit>().state;
    return Scaffold(
      body: Padding(
        padding: AppPadding.page,
        child: ListView(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: MyBackButton(),
            ),
            const SizedBox(height: AppSpacing.lg),
            SearchBar(
              leading: const Icon(
                Icons.search,
                color: AppColors.eerieBlack,
              ),
              onSubmitted: (value) {
                print(value);
              },
              controller: controller,
              backgroundColor:
                  const MaterialStatePropertyAll(AppColors.aquamarine),
              hintText: "Search user name",
            ),
            const SizedBox(height: AppSpacing.sm),
            Text("User found:", style: AppTextStyle.body),
            const SizedBox(height: AppSpacing.md),
            for (int i = 0; i < exploreState.users.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: UserContainer(
                  user: exploreState.users[i],
                  tapAdd: () {},
                  tapDelete: () {},
                  tapViewProfile: () {},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
