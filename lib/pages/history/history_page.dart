import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/core/back_button.dart';
import 'package:jogging/core/constants.dart';
import 'package:jogging/core/cubit/app_cubit.dart';
import 'package:jogging/pages/history/history_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  static Route<void> page() =>
      MaterialPageRoute<void>(builder: (_) => const HistoryPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => HistoryCubit(
            userRepository: context.read<AppCubit>().userRepository,
          )),
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
    int listLength = 0;
    print(listLength);
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return Scaffold(
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: listLength != 0
                    ? ListView.builder(
                        itemCount: listLength,
                        itemBuilder: (context, index) => const ListTile(
                          leading: Text("waiii"),
                        ),
                      )
                    : const Text('It seams that there is nothing here yet'),
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: AppColors.fernGreen,
            actions: const [],
          ),
          body: const Padding(
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
