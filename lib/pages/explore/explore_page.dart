import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/widgets/back_button.dart';
import 'package:jogging/pages/explore/explore_cubit.dart';
import 'package:jogging/pages/explore/explore_find_friends_view.dart';

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
    final userState = context.read<AppCubit>().state.user;

    return Scaffold(
      appBar: AppBar(
        actions: [
          // const MyBackButton(),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () {
              context
                  .read<ExploreCubit>()
                  .togglePendingRequests(userState!.uid);
            },
            child: Text(
              switch (exploreState.displayPendingRequests) {
                false => "Display Pending Requests",
                true => "Find New Friends",
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppPadding.page,
        child: exploreState.displayPendingRequests
            ? ListView(
                children: [
                  Text("Pending Friend Requests", style: AppTextStyle.body),
                  const Text("There are no pending requests"),
                  const SizedBox(height: AppSpacing.md),
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  Text("Received Friend Requests", style: AppTextStyle.body),
                  if (exploreState.friendRequests.isEmpty)
                    const Text("There are no friend requests received")
                  else
                    for (int i = 0; i < exploreState.friendRequests.length; i++)
                      Text(exploreState.friendRequests[i].toString()),
                ],
              )
            : ExploreFindNewFriends(
                exploreState: exploreState,
                controller: controller,
                userState: userState,
              ),
      ),
    );
  }
}
