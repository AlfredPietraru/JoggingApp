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
            receivedFriendRequests: [],
            receivedFriendRequestsUsers: [],
            sentFriendRequests: [],
            sentFriendRequestsUsers: [],
          ),
        ) {
    getInitialInfoFromServer();
  }

  void cancelFriendRequest(FriendRequest request, User user) {
    userRepository.deleteFriendRequest(request);
    final sentFriendRequests = [...state.sentFriendRequests];
    sentFriendRequests.remove(request);
    final sentFriendRequestsUsers = [...state.sentFriendRequestsUsers];
    sentFriendRequestsUsers.remove(user);
    emit(
      state.copyWith(
        sentFriendRequests: sentFriendRequests,
        sentFriendRequestsUsers: sentFriendRequestsUsers,
      ),
    );
  }

  final int limitUsersSelected = 3;
  final UserRepository userRepository;
  Future<void> getInitialInfoFromServer() async {
    final listResult = await userRepository.getAllUsers(limitUsersSelected);
    emit(state.copyWith(users: List.from(state.users)..addAll(listResult)));
  }

  Future<void> togglePendingRequests(String uid) async {
    if (!state.displayPendingRequests) {
      emit(state.copyWith(status: ExploreError.loading));
      final receivedFriendRequests =
          await userRepository.checkReceivedFriendRequests(uid);
      final sentFriendRequests =
          await userRepository.getSentFriendRequests(uid);
      final sentFriendRequestsUsers = await userRepository.getMultipleUsers(
          sentFriendRequests.map((e) => e.receiverId).toList());
      final receivedFriendRequestsUsers = await userRepository.getMultipleUsers(
          receivedFriendRequests.map((e) => e.senderId).toList());
      emit(state.copyWith(
        receivedFriendRequests: receivedFriendRequests,
        displayPendingRequests: true,
        sentFriendRequests: sentFriendRequests,
        receivedFriendRequestsUsers: receivedFriendRequestsUsers,
        sentFriendRequestsUsers: sentFriendRequestsUsers,
        status: ExploreError.noError,
      ));
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
