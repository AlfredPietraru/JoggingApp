part of 'app_cubit.dart';

enum AppStatus { initializing, unauthenticated, authenticated }

class AppState extends Equatable {
  const AppState({
    required this.user,
    required this.status,
  });

  final User? user;
  final AppStatus status;

  @override
  List<Object?> get props => [
        user,
        status,
      ];
}
