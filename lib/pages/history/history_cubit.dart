import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/run_session.dart';
import 'package:jogging/auth/user.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({required this.user, required this.userRepository})
      : super(HistoryState(
          displayOnMap: false,
          idx: 0,
          allRuns: const [],
          timeSpeedArray: const [],
          runSession: RunSession.initialRunSession(user, DateTime.now()),
        )) {
    initialize();
  }

  final int chunkSize = 10;
  final UserRepository userRepository;
  final User user;

  void initialize() async {
    List<String> toOutput = [];
    for (int i = user.numberOfRuns - 1; i >= 0; i--) {
      toOutput.add("run_${i.toString()}");
    }
    if (user.numberOfRuns > 0) {
      RunSession? runSession =
          await userRepository.returnRunData(user, toOutput[0]);
      if (runSession == null) return;
      emit(
        state.copyWith(
            allRuns: toOutput,
            runSession: runSession,
            timeSpeedArray: createTimeSpeedArray(runSession)),
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

  List<(int, double)> createTimeSpeedArray(RunSession session) {
    List<(int, double)> out = [(0, 0)];
    Random random = Random(5703);
    int N = session.returnDataSize();
    int numberChunks = 1;
    if (N % chunkSize == 0) {
      numberChunks = (N / chunkSize).floor();
    } else {
      numberChunks = (N / chunkSize).ceil();
    }

    for (int i = 1; i < numberChunks - 1; i++) {
      Set idxList = {};
      for (int k = 0; k < 3; k++) {
        idxList.add(i * chunkSize + random.nextInt(chunkSize - 1) + 1);
      }
      final orderedIdxList = List.from(idxList);
      orderedIdxList.sort();
      for (final index in orderedIdxList) {
        int currentTime = session.returnFromTimeList(index);
        int previousTime = session.returnFromTimeList(index - 1);
        if (currentTime == previousTime) continue;
        double currentSpeed = (session.returnFromDistanceList(index) -
                session.returnFromDistanceList(index - 1)) /
            (currentTime - previousTime);
        out.add((currentTime, (currentSpeed * 100).round() / 100));
      }
    }
    int finalIndex = -1;
    if (N - (numberChunks - 1) * chunkSize == 1) {
      finalIndex = (numberChunks - 1) * chunkSize;
    } else {
      finalIndex = (numberChunks - 1) * chunkSize +
          random.nextInt(N - (numberChunks - 1) * chunkSize);
    }
    int lastTime = session.returnFromTimeList(finalIndex);
    int lastPreviousTime = session.returnFromTimeList(finalIndex - 1);
    if (lastTime == lastPreviousTime) return out;
    double lastSpeed = (session.returnFromDistanceList(finalIndex) -
            session.returnFromDistanceList(finalIndex - 1)) /
        (lastTime - lastPreviousTime);
    out.add((lastTime, lastSpeed));
    return out;
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
        await userRepository.returnRunData(user, state.allRuns[index]);
    if (runSession == null) return;
    emit(state.copyWith(
      idx: index,
      runSession: runSession,
      timeSpeedArray: createTimeSpeedArray(runSession),
    ));
  }

  void displayOnMap() {
    emit(state.copyWith(displayOnMap: state.displayOnMap));
  }
}
