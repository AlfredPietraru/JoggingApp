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
  
  const HistoryInitial({
    required this.runSession,
    required this.allRuns,
    required this.idx,
  });

  HistoryInitial copyWith({
    List<String>? allRuns,
    int? idx,
    RunSession? runSession,
  }) {
    return HistoryInitial(
      allRuns: allRuns ?? this.allRuns,
      idx: idx ?? this.idx,
      runSession: runSession ?? this.runSession,
    );
  }

  @override
  List<Object> get props => [idx, allRuns, runSession];
}
