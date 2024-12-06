import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/friend_request.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required this.userRepository})
      : super(
          const ExploreState(
              name: "",
              users: [],
              status: ExploreError.noError,
              displayPendingRequests: false,
              friendRequests: []),
        ) {
    getInitialInfoFromServer();
  }

  final int limitUsersSelected = 3;
  final UserRepository userRepository;
  Future<void> getInitialInfoFromServer() async {
    final listResult = await userRepository.getAllUsers(limitUsersSelected);
    emit(state.copyWith(users: List.from(state.users)..addAll(listResult)));
  }

  Future<void> togglePendingRequests(String uid) async {
    if (!state.displayPendingRequests) {
      final result = await userRepository.checkReceivedFriendRequests(uid);
      emit(
          state.copyWith(friendRequests: result, displayPendingRequests: true));
      return;
    }
    emit(state.copyWith(displayPendingRequests: false));
  }

  Future<void> getNextUsers(User self) async {
    final listResult = await userRepository.getNonRepeatingUsers(
        _getListOfUsersFirebaseMustIgnore(self), limitUsersSelected);
    print(listResult);
    if (listResult.isEmpty) {
      emit(state.copyWith(status: ExploreError.noUsersFoundError));
      return;
    }
    emit(state.copyWith(users: List.from(state.users)..addAll(listResult)));
  }

  Future<void> sendFriendRequest(
      String senderId, String receiverId, String message) async {
    FriendRequest request = FriendRequest(
      notificationSend: false,
      timeOfSending: DateTime.now(),
      greetingMessage: message,
      senderId: senderId,
      receiverId: receiverId,
    );
    userRepository.sendFriendRequest(request);
  }

  void deleteUserFromView(String uid) {
    if (state.users.isEmpty) return;
    if (state.users.length == 1) emit(state.copyWith(users: []));
    emit(state.copyWith(
        users: List.from(state.users.where((u) => u.uid != uid))));
  }

  List<User> _getListOfUsersFirebaseMustIgnore(User self) {
    return [...state.users, self];
  }
}
