part of 'explore_cubit.dart';

enum ExploreError { noError, noUsersFoundError, loading}

class ExploreState extends Equatable {
  final String name;
  final List<String> userIds;
  final List<User> storedUsers;
  final ExploreError status;

  const ExploreState({
    required this.userIds,
    required this.status,
    required this.storedUsers,
    required this.name,
  });

  ExploreState copyWith({
    String? name,
    List<User>? storedUsers,
    ExploreError? status,
    bool? displayPendingRequests,
    List<String>? userIds,
  }) {
    return ExploreState(
      storedUsers: storedUsers ?? this.storedUsers,
      name: name ?? this.name,
      status: status ?? this.status, 
      userIds: userIds ?? this.userIds,
    );
  }

  @override
  List<Object> get props => [
        name,
        storedUsers,
        status,
        userIds,
      ];
}
