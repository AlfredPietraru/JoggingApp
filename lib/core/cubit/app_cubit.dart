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
    final user = userRepository.getUserFromMemory();
    if (user == null) {
      emit(const AppState(user: null, status: AppStatus.unauthenticated));
      return;
    }
    emit(AppState(user: user, status: AppStatus.authenticated));
  }
}
