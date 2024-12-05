import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/user.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required this.userRepository})
      : super(const ExploreState(
            name: "", users: [], status: ExploreError.noError)) {
    getInitialInfoFromServer();
  }

  final int limitUsersSelected = 3;
  final UserRepository userRepository;
  Future<void> getInitialInfoFromServer() async {
    final listResult = await userRepository.getAllUsers(limitUsersSelected);
    emit(state.copyWith(users: List.from(state.users)..addAll(listResult)));
    // userRepository.getUserFromDatabase(id)
  }

  Future<void> getNextUsers() async {
    final listResult = await userRepository.getNonRepeatingUsers(
        state.users, limitUsersSelected);
    print(listResult);
    if (listResult.isEmpty) {
      emit(state.copyWith(status: ExploreError.noUsersFoundError));
      return;
    }
    emit(state.copyWith(users: List.from(state.users)..addAll(listResult)));
  }

  void deleteUserFromView(String uid) {
    if (state.users.isEmpty) return;
    if (state.users.length == 1) emit(state.copyWith(users: []));
    emit(state.copyWith(
        users: List.from(state.users.where((u) => u.uid != uid))));
  }
}
