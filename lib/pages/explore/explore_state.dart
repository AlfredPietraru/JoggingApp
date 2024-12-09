part of 'explore_cubit.dart';

enum ExploreError { noError, noUsersFoundError, loading }

class ExploreState extends Equatable {
  final String name;
  final List<User> users;
  final ExploreError status;
  final bool displayPendingRequests;
  final List<FriendRequest> receivedFriendRequests;
  final List<FriendRequest> sentFriendRequests;
  final List<User> receivedFriendRequestsUsers;
  final List<User> sentFriendRequestsUsers;

  const ExploreState({
    required this.receivedFriendRequests,
    required this.sentFriendRequests,
    required this.receivedFriendRequestsUsers,
    required this.sentFriendRequestsUsers,
    required this.displayPendingRequests,
    required this.status,
    required this.users,
    required this.name,
  });

  ExploreState copyWith({
    String? name,
    List<User>? users,
    ExploreError? status,
    bool? displayPendingRequests,
    List<FriendRequest>? receivedFriendRequests,
    List<FriendRequest>? sentFriendRequests,
    List<User>? receivedFriendRequestsUsers,
    List<User>? sentFriendRequestsUsers,
  }) {
    return ExploreState(
      users: users ?? this.users,
      name: name ?? this.name,
      status: status ?? this.status,
      displayPendingRequests:
          displayPendingRequests ?? this.displayPendingRequests,
      receivedFriendRequests:
          receivedFriendRequests ?? this.receivedFriendRequests,
      sentFriendRequests: sentFriendRequests ?? this.sentFriendRequests,
      receivedFriendRequestsUsers:
          receivedFriendRequestsUsers ?? this.receivedFriendRequestsUsers,
      sentFriendRequestsUsers:
          sentFriendRequestsUsers ?? this.sentFriendRequestsUsers,
    );
  }

  @override
  List<Object> get props => [
        name,
        users,
        status,
        displayPendingRequests,
        sentFriendRequestsUsers,
        sentFriendRequests,
        receivedFriendRequests,
        receivedFriendRequestsUsers
      ];
}
