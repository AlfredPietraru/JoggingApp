part of 'explore_cubit.dart';

class ExploreState extends Equatable {
  final String name;
  final List<User> users;
  const ExploreState({required this.users, required this.name});

  ExploreState copyWith({
    String? name,
    List<User>? users,
  }) {
    return ExploreState(users: users ?? this.users, name: name ?? this.name);
  }

  @override
  List<Object> get props => [name, users];
}
