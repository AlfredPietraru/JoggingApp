import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  late GoogleMapController mapController;
  final TextStyle generalStyle = AppTextStyle.body.copyWith(fontSize: 20);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xlg),
                child: state.allRuns.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.allRuns.length,
                        itemBuilder: (context, index) => _LocalListTile(
                          name: state.allRuns[index],
                          onTap: () {
                            context.read<HistoryCubit>().selectNewRun(index);
                            Navigator.pop(context);
                          },
                          isSelected: index == state.idx,
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
            actions: const [MyBackButton(), SizedBox(width: AppSpacing.xxlg)],
          ),
          body: Container(
            child: state.runSession.coordinates.isEmpty
                ? const Text("No element found")
                : Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: state.timeSpeedArray.isEmpty
                              ? const CircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      right: AppSpacing.xlg),
                                  child: LineChart(
                                    LineChartData(
                                      gridData: FlGridData(
                                        show: true,
                                        drawHorizontalLine: true,
                                        drawVerticalLine: true,
                                        horizontalInterval: 50,
                                        verticalInterval: 50,
                                        getDrawingHorizontalLine: (value) {
                                          return FlLine(
                                            color: AppColors.eerieBlack
                                                .withOpacity(0.5),
                                            strokeWidth: 2,
                                          );
                                        },
                                        getDrawingVerticalLine: (value) {
                                          return FlLine(
                                            color: AppColors.hunterGreen
                                                .withOpacity(0.5),
                                            strokeWidth: 2,
                                          );
                                        },
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 22,
                                            interval: context
                                                .read<HistoryCubit>()
                                                .setDataInterval(),
                                            getTitlesWidget: (value, meta) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: AppSpacing.sm),
                                                child: Text(
                                                  context
                                                      .read<HistoryCubit>()
                                                      .convertToClockFormat(
                                                          value),
                                                  style: const TextStyle(
                                                    color: AppColors.eerieBlack,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 60,
                                            interval: 1,
                                            getTitlesWidget: (value, meta) {
                                              return Text(
                                                "${value.toStringAsFixed(1)}m/s",
                                                style: const TextStyle(
                                                  color: AppColors.eerieBlack,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        topTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                        rightTitles: const AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false),
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        border: Border.all(
                                            color: const Color(0xff37434d)),
                                      ),
                                      minX: 0,
                                      minY: context
                                          .read<HistoryCubit>()
                                          .getMinSpeed(),
                                      maxY: context
                                          .read<HistoryCubit>()
                                          .getMaximSpeed(),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: List.from(state.timeSpeedArray
                                              .map((e) => FlSpot(
                                                  e.$1.toDouble(), e.$2))),
                                          isCurved: true,
                                          barWidth: 5,
                                          isStrokeCapRound: true,
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: Colors.blueAccent
                                                .withOpacity(0.2),
                                          ),
                                          dotData: FlDotData(
                                            show: true,
                                            checkToShowDot: (spot, barData) =>
                                                true,
                                            getDotPainter: (spot, percent,
                                                barData, index) {
                                              return FlDotCirclePainter(
                                                radius: 4,
                                                color: Colors.redAccent,
                                                strokeWidth: 2,
                                                strokeColor:
                                                    AppColors.eerieBlack,
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.linear,
                                  ),
                                ),
                        ),
                        const SizedBox(height: AppSpacing.xlg),
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Starting Time:", style: generalStyle),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppSpacing.sm),
                                  child: Text(
                                      state.runSession.dateTime.toString(),
                                      style: generalStyle),
                                ),
                                const Divider(),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  "Duration: ${context.read<HistoryCubit>().getTime()}",
                                  style: generalStyle,
                                ),
                                const Divider(),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  "Distance traveld: ${context.read<HistoryCubit>().getDistance(MeasurementUnit.kilometers)} km",
                                  style: generalStyle,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: SizedBox(
                            height: 400,
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: context
                                    .read<HistoryCubit>()
                                    .setStartingPoint(),
                                zoom: 15.0,
                              ),
                              polylines: <Polyline>{
                                Polyline(
                                  polylineId: const PolylineId("path"),
                                  color: Colors.red,
                                  consumeTapEvents: true,
                                  width: 4,
                                  points: context
                                      .read<HistoryCubit>()
                                      .allGraphPoints(),
                                )
                              },
                              markers: {
                                Marker(
                                  markerId:
                                      const MarkerId('InitialUserLocation'),
                                  position: context
                                      .read<HistoryCubit>()
                                      .setStartingPoint(),
                                  infoWindow: const InfoWindow(
                                      title: 'Initial Location'),
                                ),
                                Marker(
                                  markerId: const MarkerId('FinalUserLocation'),
                                  position: context
                                      .read<HistoryCubit>()
                                      .setEndPoint(),
                                  infoWindow: const InfoWindow(
                                      title: 'FinalUserLocation'),
                                ),
                              },
                              gestureRecognizers: Set()
                                ..add(
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
