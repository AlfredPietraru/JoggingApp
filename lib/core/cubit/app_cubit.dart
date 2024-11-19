import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/user.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required this.userRepository})
      : super(const AppState(
          user: null,
          status: AppStatus.initializing,
        )) {
    initialize();
  }

  final UserRepository userRepository;

  void initialize() async {
    User? user = userRepository.getUserFromMemory();
    if (user == null) {
      emit(const AppState(user: null, status: AppStatus.unauthenticated));
      return;
    }
    emit(AppState(user: user, status: AppStatus.authenticated));
  }

  void setUser(User user) {
    emit(
      state.copyWith(user: user, status: AppStatus.authenticated),
    );
  }

  void addRunToUser() {
    List<String> oldRuns = state.user!.runs;
    List<String> newRuns = [...oldRuns, "run_${state.user!.numberOfRuns}"];
    emit(state.copyWith(
        user: state.user!.copyWith(
            runs: newRuns, numberOfRuns: state.user!.numberOfRuns + 1)));
  }

  void changeUserInformation(
      {String? firstName,
      String? lastName,
      int? age,
      Sex? sex,
      List<String>? runs}) {
    User newUser = state.user!.copyWith(
        lastName: lastName,
        firstName: firstName,
        age: age,
        sex: sex,
        runs: runs);
    emit(state.copyWith(user: newUser));
    userRepository.writeUserToMemory(newUser);
    userRepository.updateUserInformation(newUser);
  }

  String getFullUserName() {
    return "${state.user!.firstName} ${state.user!.lastName}";
  }

  void deleteUserFromMemory() async {
    userRepository.deleteUserFromMemory();
  }
}
