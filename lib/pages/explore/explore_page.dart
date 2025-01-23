import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/friend_request.dart';
import 'package:jogging/core/widgets/back_button.dart';
import 'package:jogging/core/widgets/message_alert_dialog.dart';
import 'package:jogging/core/widgets/user_container.dart';
import 'package:jogging/pages/explore/explore_cubit.dart';
import 'package:jogging/pages/friend_requests/friend_requests_page.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const Explore());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExploreCubit(
        userId: context.read<AppCubit>().state.user!.uid,
        userRepository: context.read<AppCubit>().userRepository,
      ),
      child: Builder(builder: (context) {
        return const _Explore();
      }),
    );
  }
}

class _Explore extends StatefulWidget {
  const _Explore();

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
        actions: [TextButton(onPressed: (){
          Navigator.push(context, FriendRequestsPage.page());
        }, child: const Text("Friend Requests")),  const SizedBox(width: 20), const MyBackButton(), const SizedBox(width: 20)],
      ),
      body: Padding(
          padding: AppPadding.page,
          child: ListView(
            children: [
              const SizedBox(height: AppSpacing.lg),
              SearchBar(
                leading: const Icon(
                  Icons.search,
                  color: AppColors.eerieBlack,
                ),
                onSubmitted: (value) {
                  print(value);
                },
                backgroundColor:
                    const MaterialStatePropertyAll(AppColors.aquamarine),
                hintText: "Search ",
              ),
              const SizedBox(height: AppSpacing.sm),
              Text("User found:", style: AppTextStyle.body),
              const SizedBox(height: AppSpacing.md),
              for (int i = 0; i < exploreState.storedUsers.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: UserContainer(
                    user: exploreState.storedUsers[i],
                    tapAdd: () {
                      final ExploreCubit exploreCubit =
                          context.read<ExploreCubit>();
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return BlocProvider<ExploreCubit>.value(
                            value: exploreCubit,
                            child: MessageAlertDialog(
                              onPressed: () {
                                context.read<ExploreCubit>().sendFriendRequest(
                                      exploreState.storedUsers[i].uid,
                                      controller.text == ""
                                          ? "Hello, let's be friends on Jogging Time."
                                          : controller.text,
                                    );
                                Navigator.pop(context);
                              },
                              controller: controller,
                              senderId: userState!.uid,
                              receiverId: exploreState.storedUsers[i].uid,
                            ),
                          );
                        },
                      );
                    },
                    tapDelete: () {
                      context
                          .read<ExploreCubit>()
                          .deleteUserFromView(exploreState.storedUsers[i].uid);
                    },
                    tapViewProfile: () {},
                  ),
                ),
              if (context.read<ExploreCubit>().state.status == ExploreError.loading)
                const Center(child: CircularProgressIndicator()),  
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: switch(exploreState.status) {
                    ExploreError.noError => () {
                      context.read<ExploreCubit>().getNextUsers();
                    },
                    ExploreError.noUsersFoundError => null,
                    ExploreError.loading => null,
                  },
                  child: Text(
                    switch (exploreState.status) {
                      ExploreError.loading => "Collecting Data",
                      ExploreError.noError => "Get more users",
                      ExploreError.noUsersFoundError =>
                        "No more users to be found.",
                    },
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        ),
    );
  }
}

class _DisplayFriendRequest extends StatelessWidget {
  const _DisplayFriendRequest({required this.request, required this.user});
  final FriendRequest request;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.eerieBlack,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.eerieBlack, width: 2),
                    ),
                    child: const Center(
                        child: Text('Aici', textAlign: TextAlign.center)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: AppTextStyle.body.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    request.greetingMessage,
                    style: AppTextStyle.body.copyWith(fontSize: 16),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
