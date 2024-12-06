part of 'explore_cubit.dart';

enum ExploreError { noError, noUsersFoundError }

class ExploreState extends Equatable {
  final String name;
  final List<User> users;
  final ExploreError status;
  final bool displayPendingRequests;
  final List<FriendRequest> friendRequests;
  const ExploreState({
    required this.friendRequests,
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
    List<FriendRequest>? friendRequests,
  }) {
    return ExploreState(
      users: users ?? this.users,
      name: name ?? this.name,
      status: status ?? this.status,
      displayPendingRequests:
          displayPendingRequests ?? this.displayPendingRequests,
      friendRequests: friendRequests ?? this.friendRequests,
    );
  }

  @override
  List<Object> get props => [name, users, status, displayPendingRequests];
}
