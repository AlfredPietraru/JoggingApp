import 'package:fl_chart/fl_chart.dart';
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
            user: context.read<AppCubit>().state.user!,
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        final oldState = state as HistoryInitial;
        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xlg),
                child: oldState.allRuns.isNotEmpty
                    ? ListView.builder(
                        itemCount: oldState.allRuns.length,
                        itemBuilder: (context, index) => _LocalListTile(
                          name: oldState.allRuns[index],
                          onTap: () {
                            context.read<HistoryCubit>().selectNewRun(index);
                            Navigator.pop(context);
                          },
                          isSelected: index == oldState.idx,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      )
                    : const Text('It seams that there is nothing here yet'),
              ),
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.more_vert_outlined, size: 60),
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            ),
            toolbarHeight: 100,
            backgroundColor: AppColors.fernGreen,
            actions: const [MyBackButton()],
          ),
          body: Padding(
            padding: AppPadding.page,
            child: oldState.runSession.coordinates.isEmpty
                ? const Text("No element found")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: true,
                              horizontalInterval: 1,
                              verticalInterval: 1,
                              getDrawingHorizontalLine: (value) {
                                return const FlLine(
                                  color: AppColors.hunterGreen,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                          ),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.linear,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _LocalListTile extends StatelessWidget {
  const _LocalListTile(
      {required this.name, required this.onTap, required this.isSelected});
  final String name;
  final Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.lg),
          side: const BorderSide(color: AppColors.enabledFieldOrange, width: 3),
        ),
        leading: isSelected
            ? const Icon(
                Icons.analytics_rounded,
                size: 40,
                color: AppColors.enabledFieldOrange,
              )
            : null,
        selected: isSelected,
        selectedTileColor: AppColors.costalBlue,
        onTap: onTap,
        trailing: Text(name, style: AppTextStyle.body),
      ),
    );
  }
}
