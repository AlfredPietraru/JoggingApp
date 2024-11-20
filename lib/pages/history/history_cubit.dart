import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/runSession.dart';
import 'package:jogging/auth/user.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({required this.user, required this.userRepository})
      : super(HistoryInitial(
          idx: 0,
          allRuns: [],
          runSession: RunSession.initialRunSession(user, DateTime.now()),
        )) {
    initialize();
  }

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
      final oldState = state as HistoryInitial;
      emit(
        oldState.copyWith(allRuns: toOutput, runSession: runSession),
      );
    }
  }

  void selectNewRun(int index) async {
    final oldState = state as HistoryInitial;
    RunSession? runSession =
        await userRepository.returnRunData(user, oldState.allRuns[index]);
    if (runSession != null) return;
    emit(oldState.copyWith(idx: index, runSession: runSession));
  }
}
