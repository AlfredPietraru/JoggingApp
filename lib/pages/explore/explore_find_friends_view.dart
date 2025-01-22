import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/widgets/user_container.dart';
import 'package:jogging/pages/explore/explore_cubit.dart';

class ExploreFindNewFriends extends StatelessWidget {
  const ExploreFindNewFriends({
    super.key,
    required this.exploreState,
    required this.controller,
    required this.userState,
  });

  final ExploreState exploreState;
  final TextEditingController controller;
  final User? userState;

  @override
  Widget build(BuildContext context) {
    return ListView(
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
          backgroundColor: const MaterialStatePropertyAll(AppColors.aquamarine),
          hintText: "Search ",
        ),
        const SizedBox(height: AppSpacing.sm),
        Text("User found:", style: AppTextStyle.body),
        const SizedBox(height: AppSpacing.md),
        for (int i = 0; i < exploreState.users.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: UserContainer(
              user: exploreState.users[i],
              tapAdd: () {
                final ExploreCubit exploreCubit = context.read<ExploreCubit>();
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider<ExploreCubit>.value(
                      value: exploreCubit,
                      child: MessageAlertDialog(
                        controller: controller,
                        senderId: userState!.uid,
                        receiverId: exploreState.users[i].uid,
                      ),
                    );
                  },
                );
              },
              tapDelete: () {
                context
                    .read<ExploreCubit>()
                    .deleteUserFromView(exploreState.users[i].uid);
              },
              tapViewProfile: () {},
            ),
          ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              context.read<ExploreCubit>().getNextUsers(userState!);
            },
            child: Text(
              switch (exploreState.status) {
                ExploreError.loading => "Collecting Data",
                ExploreError.noError => "Get more users",
                ExploreError.noUsersFoundError => "No more users to be found.",
              },
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class MessageAlertDialog extends StatelessWidget {
  const MessageAlertDialog({
    super.key,
    required this.controller,
    required this.senderId,
    required this.receiverId,
  });
  final TextEditingController controller;
  final String senderId;
  final String receiverId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Send a friend request?",
        style: AppTextStyle.alert.copyWith(
          color: AppColors.hunterGreen,
        ),
      ),
      content: SizedBox(
        height: 200,
        width: 300,
        child: Column(
          children: [
            Text(
              "You are about to send a friend request to this person. Are you sure about it?",
              style:
                  AppTextStyle.alert.copyWith(color: AppColors.pakistanGreen),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              decoration: const InputDecoration(
                filled: true,
                fillColor: AppColors.aquamarine,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.hunterGreen, width: 3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.enabledFieldOrange, width: 3),
                ),
                hintText: "Hello, let's be friends on Jogging Time.",
              ),
              controller: controller,
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.enabledFieldOrange,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: AppTextStyle.alert.copyWith(color: AppColors.hunterGreen),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ExploreCubit>().sendFriendRequest(
                  senderId,
                  receiverId,
                  controller.text == ""
                      ? "Hello, let's be friends on Jogging Time."
                      : controller.text,
                );
            Navigator.pop(context);
          },
          child: Text(
            "Send",
            style: AppTextStyle.alert.copyWith(color: AppColors.hunterGreen),
          ),
        ),
      ],
    );
  }
}
