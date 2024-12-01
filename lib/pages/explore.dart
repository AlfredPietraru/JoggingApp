import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('go back'),
          ),
          ElevatedButton(
              onPressed: () {
                print(context.read<AppCubit>().state.user);
              },
              child: const Text("Print state of affair"))
        ],
      ),
    );
  }
}
