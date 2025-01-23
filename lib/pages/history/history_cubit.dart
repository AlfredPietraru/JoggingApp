import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/run_session.dart';
part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({required this.numberOfRuns, required this.userRepository, required this.uid})
      : super(HistoryState(
          displayOnMap: false,
          idx: 0,
          allRuns: const [],
          timeSpeedArray: const [],
          runSession: RunSession.initialRunSession(DateTime.now()),
        )) {
    initialize();
  }

  final int chunkSize = 10;
  final int maxSelected = 3;
  final UserRepository userRepository;
  final int numberOfRuns;
  final String uid;

  void initialize() async {
    List<String> toOutput = [];
    for (int i = 1; i <= numberOfRuns; i++) {
      toOutput.add("run_${i.toString()}");
    }

    if (numberOfRuns > 0) {
      RunSession? runSession =
          await userRepository.returnRunData(uid, toOutput[0]);
      if (runSession == null) return;
      emit(
        state.copyWith(
            allRuns: toOutput,
            runSession: runSession,
            timeSpeedArray: runSession.createTimeSpeedArray(chunkSize, maxSelected)),
      );
    }
  }

  LatLng setStartingPoint() {
    if (state.runSession.coordinates.isEmpty) return const LatLng(4, 4);
    return state.runSession.coordinates[0].first;
  }

  LatLng setEndPoint() {
    if (state.runSession.coordinates.isEmpty) return const LatLng(4, 4);
    return state.runSession.coordinates.last.last;
  }

  String convertToClockFormat(double value) {
    int hours = value ~/ 3600;
    int minutes = (value % 3600) ~/ 60;
    int seconds = (value % 60).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  List<LatLng> allGraphPoints() {
    if (state.runSession.coordinates.isEmpty) return [];
    List<LatLng> out = [...state.runSession.coordinates[0]];
    for (int i = 1; i < state.runSession.coordinates.length; i++) {
      out = out + [...state.runSession.coordinates[i]];
    }
    return out;
  }

  List<(int, double)> createTimeSpeedArray() {
    return state.runSession.createTimeSpeedArray(chunkSize, maxSelected);
  }
  
  double setDataInterval() {
    int totalTime = state.runSession.times.last.last;
    return (totalTime / 3 * 100).round() / 100;
  }

  double getMinSpeed() {
    (int, double) value = state.timeSpeedArray
        .reduce((curr, next) => curr.$2 < next.$2 ? curr : next);
    return max(value.$2 - 0.5, 0);
  }

  double getDistance(MeasurementUnit unit) {
    if (state.runSession.distances.isEmpty) return 0;
    return switch (unit) {
      MeasurementUnit.meters => state.runSession.distances.last.last,
      MeasurementUnit.kilometers =>
        (state.runSession.distances.last.last).round() / 1000
    };
  }

  String getTime() {
    if (state.runSession.times.isEmpty) return "00:00";
    int value = state.runSession.times.last.last;
    int hours = value ~/ 3600;
    int minutes = (value % 3600) ~/ 60;
    int seconds = (value % 60).toInt();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double getMaximSpeed() {
    (int, double) value = state.timeSpeedArray.reduce((curr, next) {
      final (_, speed1) = curr;
      final (_, speed2) = next;
      return speed1 > speed2 ? curr : next;
    });
    return value.$2 + 0.5;
  }

  void selectNewRun(int index) async {
    RunSession? runSession =
        await userRepository.returnRunData(uid, state.allRuns[index]);
    if (runSession == null) {
      print("Nu s-a gasit runn-ul potrivit");
      return;
    } 
    emit(state.copyWith(
      idx: index,
      runSession: runSession,
      timeSpeedArray: runSession.createTimeSpeedArray(chunkSize, maxSelected),
    ));
  }

  void displayOnMap() {
    emit(state.copyWith(displayOnMap: state.displayOnMap));
  }
}
