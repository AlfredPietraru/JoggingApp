part of 'history_cubit.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

final class HistoryInitial extends HistoryState {
  final int idx;
  final List<String> allRuns;
  final List<double> distance;
  final List<double> timeValues;
  const HistoryInitial({
    required this.distance,
    required this.timeValues,
    required this.allRuns,
    required this.idx,
  });

  HistoryInitial copyWith({
    List<String>? allRuns,
    int? idx,
    List<String>? runData,
    List<double>? distance,
    List<double>? timeValues,
  }) {
    return HistoryInitial(
      allRuns: allRuns ?? this.allRuns,
      idx: idx ?? this.idx,
      distance: distance ?? this.distance,
      timeValues: timeValues ?? this.timeValues,
    );
  }

  @override
  List<Object> get props => [idx, allRuns, distance, timeValues];
}
