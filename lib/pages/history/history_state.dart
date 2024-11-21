part of 'history_cubit.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

final class HistoryInitial extends HistoryState {
  final int idx;
  final List<String> allRuns;
  final RunSession runSession;
  final List<(int, double)> timeSpeedArray;

  const HistoryInitial({
    required this.timeSpeedArray,
    required this.runSession,
    required this.allRuns,
    required this.idx,
  });

  HistoryInitial copyWith({
    List<String>? allRuns,
    int? idx,
    RunSession? runSession,
    List<(int, double)>? timeSpeedArray,
  }) {
    return HistoryInitial(
      allRuns: allRuns ?? this.allRuns,
      idx: idx ?? this.idx,
      runSession: runSession ?? this.runSession,
      timeSpeedArray: timeSpeedArray ?? this.timeSpeedArray,
    );
  }

  @override
  List<Object> get props => [idx, allRuns, runSession];
}
