import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/core/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/pages/history/history_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const HistoryPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => HistoryCubit()),
      child: Builder(builder: (context) {
        return BlocListener<HistoryCubit, HistoryState>(
          listener: (context, state) {},
          child: const _HistoryPage(),
        );
      }),
    );
  }
}

class _HistoryPage extends StatefulWidget {
  const _HistoryPage();

  @override
  State<_HistoryPage> createState() => __HistoryPageState();
}

class __HistoryPageState extends State<_HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return const Scaffold(
          body: Padding(
            padding: AppPadding.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyBackButton(),
                Text("hello"),
              ],
            ),
          ),
        );
      },
    );
  }
}
