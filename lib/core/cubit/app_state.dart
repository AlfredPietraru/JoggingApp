part of 'app_cubit.dart';

enum AppStatus { initializing, unauthenticated, authenticated, lostConnection}

class AppState extends Equatable {
  const AppState({
    required this.user,
    required this.status,
  });

  final User? user;
  final AppStatus status;
  AppState copyWith({User? user, AppStatus? status}) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        user,
        status,
      ];
}
