import 'package:equatable/equatable.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/core/friend_request.dart';

class FriendRequestState extends Equatable {
  final List<String> allFriendsIds;
  final List<User> friendsDisplayed;
  final List<FriendRequest> sentFriendRequest;
  final List<FriendRequest> receivedFriendRequest;

  const FriendRequestState({required this.allFriendsIds, required this.receivedFriendRequest, required this.friendsDisplayed, required this.sentFriendRequest});
  
  
  @override
  List<Object?> get props => [allFriendsIds, receivedFriendRequest, sentFriendRequest, friendsDisplayed];
  
}
