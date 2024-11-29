part of 'history_cubit.dart';



enum MeasurementUnit {
  meters,
  kilometers,
}

final class HistoryState extends Equatable {
  final int idx;
  final List<String> allRuns;
  final RunSession runSession;
  final List<(int, double)> timeSpeedArray;
  final bool displayOnMap;

  const HistoryState({
    required this.displayOnMap,
    required this.timeSpeedArray,
    required this.runSession,
    required this.allRuns,
    required this.idx,
  });

  HistoryState copyWith({
    List<String>? allRuns,
    int? idx,
    RunSession? runSession,
    List<(int, double)>? timeSpeedArray,
    bool? displayOnMap,
  }) {
    return HistoryState(
      displayOnMap: displayOnMap ?? this.displayOnMap,
      allRuns: allRuns ?? this.allRuns,
      idx: idx ?? this.idx,
      runSession: runSession ?? this.runSession,
      timeSpeedArray: timeSpeedArray ?? this.timeSpeedArray,
    );
  }

  @override
  List<Object> get props => [idx, allRuns, runSession, displayOnMap];
}
