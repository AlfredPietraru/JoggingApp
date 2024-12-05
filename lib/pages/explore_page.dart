import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/core/user_container.dart';

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
            UserContainer(
              user: user,
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
