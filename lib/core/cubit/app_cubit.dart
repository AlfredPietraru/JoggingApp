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

  void changeUserInformation(
      {String? firstName, String? lastName, int? age, Sex? sex}) {
    User newUser = user!
        .copyWith(lastName: lastName, firstName: firstName, age: age, sex: sex);
    emit(state.copyWith(user: newUser));
    userRepository.writeUserToMemory(newUser);
    print("a scris in memoria interna");
    userRepository.updateUserInformation(newUser);
  }

  String getFullUserName() {
    return "${user!.firstName} ${user!.lastName}";
  }

  void deleteUserFromMemory() async {
    userRepository.deleteUserFromMemory();
  }
}
