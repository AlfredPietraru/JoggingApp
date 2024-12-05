part of 'explore_cubit.dart';

class ExploreState extends Equatable {
  final String name;
  final List<User> userId;
  const ExploreState({required this.userId, required this.name});

  @override
  List<Object> get props => [name, userId];
}
