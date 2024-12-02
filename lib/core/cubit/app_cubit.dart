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
      if (event == null) {
        emit(state.copyWith(user: event, status: AppStatus.unauthenticated));
      } else {
        emit(state.copyWith(user: event, status: AppStatus.authenticated));
      }
    });

    firebaseSubscription = userRepository.userIdString().listen((id) async {
      if (id == null) {
        print("Userul nu este authentificat");
        emit(const AppState(user: null, status: AppStatus.unauthenticated));
        return;
      }
      User? user = await userRepository.getUserFromDatabase(id);
      if (user == null) {
        emit(const AppState(user: null, status: AppStatus.lostConnection));
        return;
      }
      userRepository.writeUserToMemory(user);
    });
  }

  void changeNumberRuns() {
    emit(state.copyWith(
        user:
            state.user!.copyWith(numberOfRuns: state.user!.numberOfRuns + 1)));
  }

  String getFullUserName() {
    return "${state.user!.firstName} ${state.user!.lastName}";
  }
}
