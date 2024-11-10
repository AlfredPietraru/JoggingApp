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

  User? user;
  final UserRepository userRepository;

  void initialize() async {
    user = userRepository.getUserFromMemory();
    if (user == null) {
      emit(const AppState(user: null, status: AppStatus.unauthenticated));
      return;
    }
    emit(AppState(user: user, status: AppStatus.authenticated));
  }

  String getFullUserName() {
    return "${user!.firstName} ${user!.lastName}";
  }

  void deleteUserFromMemory() async {
    userRepository.deleteUserFromMemory();
  }
}
