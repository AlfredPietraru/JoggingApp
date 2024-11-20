import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/user.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit({required this.user, required this.userRepository})
      : super(const HistoryInitial(
            idx: 0, allRuns: [], distance: [], timeValues: [])) {
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
      List<String> runData =
          await userRepository.returnRunData(user, toOutput[0]);
      emit(
        (state as HistoryInitial).copyWith(allRuns: toOutput, runData: runData),
      );
    }
  }

  void selectNewRun(int index) async {
    final oldState = state as HistoryInitial;
    List<String> runData = await userRepository.returnRunData(
        user, oldState.allRuns[oldState.idx]);
    emit(oldState.copyWith(idx: index, runData: runData));
  }
}
