import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/friend_request.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required this.userRepository, required this.userId})
      : super(
          const ExploreState(
            name: "",
            storedUsers: [],
            status: ExploreError.noError, 
            userIds: [],
          ),
        ) {
    getInitialInfoFromServer();
  }

  // void cancelFriendRequest(FriendRequest request, User user) {
  //   userRepository.deleteFriendRequest(request);
  //   final sentFriendRequests = [...state.sentFriendRequests];
  //   sentFriendRequests.remove(request);
  //   final sentFriendRequestsUsers = [...state.sentFriendRequestsUsers];
  //   sentFriendRequestsUsers.remove(user);
  //   emit(
  //     state.copyWith(
  //       sentFriendRequests: sentFriendRequests,
  //       sentFriendRequestsUsers: sentFriendRequestsUsers,
  //     ),
  //   );
  // }

  final String userId;
  final int limitUsersSelected = 3;
  final UserRepository userRepository;
  Future<void> getInitialInfoFromServer() async {
    final someUsersIds = await userRepository.getLimitedUserIds(100);
    someUsersIds.remove(userId);
    emit(state.copyWith(status: ExploreError.loading));
    final listResult = await userRepository.getMultipleUsers(someUsersIds.sublist(0, limitUsersSelected));
    emit(state.copyWith(storedUsers: List.from(state.storedUsers)..addAll(listResult), userIds: someUsersIds, status: ExploreError.noError));
  }

  Future<void> getNextUsers() async {
    int startSelection = state.storedUsers.length;
    int endSelection = (state.storedUsers.length + limitUsersSelected >= state.userIds.length) ? 
          state.userIds.length : state.storedUsers.length + limitUsersSelected; 
    emit(state.copyWith(status: ExploreError.loading));
    final listResult = await userRepository.getMultipleUsers(state.userIds.sublist(startSelection, endSelection));
    print(listResult);
    if (listResult.isEmpty) {
      emit(state.copyWith(status: ExploreError.noUsersFoundError));
      return;
    }
    if (listResult.length < 4) {
      emit(state.copyWith(storedUsers: List.from(state.storedUsers)..addAll(listResult), status: ExploreError.noUsersFoundError));  
      return;
    }
    emit(state.copyWith(storedUsers: List.from(state.storedUsers)..addAll(listResult), status: ExploreError.noError));
  }

  Future<void> sendFriendRequest(String receiverId, String message) async {
    FriendRequest request = FriendRequest(
      notificationSend: false,
      timeOfSending: DateTime.now(),
      greetingMessage: message,
      senderId: userId,
      receiverId: receiverId,
    );
    userRepository.sendFriendRequest(request);
  }

  void deleteUserFromView(String uid) {
    if (state.storedUsers.isEmpty) return;
    if (state.storedUsers.length == 1) emit(state.copyWith(storedUsers: []));
    final userIds = state.userIds;
    userIds.remove(uid);
    emit(state.copyWith(
        storedUsers: List.from(state.storedUsers.where((u) => u.uid != uid)), userIds: [...userIds]));
  }
}
