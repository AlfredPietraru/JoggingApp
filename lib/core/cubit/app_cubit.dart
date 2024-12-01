import 'dart:async';

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
  late final StreamSubscription<String?> firebaseSubscription;
  late final StreamSubscription<User?> sharedPrefsSubscription;

  @override
  Future<void> close() {
    firebaseSubscription.cancel();
    sharedPrefsSubscription.cancel();
    return super.close();
  }

  void initialize() async {
    sharedPrefsSubscription =
        userRepository.getLocalUserStream().listen((event) {
      emit(state.copyWith(user: event));
    });

    firebaseSubscription = userRepository.userIdString().listen((id) async {
      if (id == null) {
        emit(const AppState(user: null, status: AppStatus.unauthenticated));
        return;
      }
      User? user = await userRepository.getUserFromDatabase(id);
      if (user == null) {
        emit(const AppState(user: null, status: AppStatus.lostConnection));
        return;
      }
      emit(AppState(user: user, status: AppStatus.authenticated));
      userRepository.writeUserToMemory(user);
    });
  }

  void changeNumberRuns() {
    emit(state.copyWith(
        user:
            state.user!.copyWith(numberOfRuns: state.user!.numberOfRuns + 1)));
  }

  void setUser(User user) {
    emit(
      state.copyWith(user: user, status: AppStatus.authenticated),
    );
    userRepository.writeUserToMemory(user);
  }

  String getFullUserName() {
    return "${state.user!.firstName} ${state.user!.lastName}";
  }

  void deleteUserFromMemory() async {
    userRepository.deleteUserFromMemory();
  }
}
