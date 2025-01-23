import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/pages/friend_requests/friend_request_state.dart';

class FriendRequestCubit extends Cubit<FriendRequestState> {
  FriendRequestCubit({required this.userRepository, required this.userId})
      : super(const FriendRequestState(
        allFriendsIds: [],
        receivedFriendRequest: [],
        sentFriendRequest: [],
        friendsDisplayed: [],
      ),
        ) {
    // somme logic here
    // init();
    }

    final UserRepository userRepository;
    final String userId;

    // void init() {
    //     userRepository.getFriendRequest(receiverId, senderId)
    // }
}