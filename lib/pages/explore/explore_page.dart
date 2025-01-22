import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/friend_request.dart';
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
                children: exploreState.status == ExploreError.loading
                    ? [
                        const CircularProgressIndicator(),
                      ]
                    : [
                        Text("Pending Friend Requests",
                            style: AppTextStyle.body),
                        if (exploreState.sentFriendRequests.isEmpty)
                          const Text("There are no pending requests")
                        else
                          for (int i = 0;
                              i < exploreState.sentFriendRequests.length;
                              i++)
                            _DisplayFriendRequest(
                                request: exploreState.sentFriendRequests[i],
                                user: exploreState.sentFriendRequestsUsers[i]),
                        const Divider(),
                        const SizedBox(height: AppSpacing.md),
                        Text("Received Friend Requests",
                            style: AppTextStyle.body),
                        if (exploreState.receivedFriendRequests.isEmpty)
                          const Text("There are no friend requests received")
                        else
                          for (int i = 0;
                              i < exploreState.receivedFriendRequests.length;
                              i++)
                            Text(exploreState.receivedFriendRequestsUsers[i]
                                .toString()),
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
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ExploreCubit>()
                          .cancelFriendRequest(request, user);
                    },
                    child: const Text("Cancel"),
                  ),
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
