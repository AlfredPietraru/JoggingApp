part of 'explore_cubit.dart';

enum ExploreError { noError, noUsersFoundError }

class ExploreState extends Equatable {
  final String name;
  final List<User> users;
  final ExploreError status;
  const ExploreState(
      {required this.status, required this.users, required this.name});

  ExploreState copyWith({
    String? name,
    List<User>? users,
    ExploreError? status,
  }) {
    return ExploreState(
      users: users ?? this.users,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [name, users, status];
}
