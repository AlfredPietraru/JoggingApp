part of 'app_cubit.dart';

enum AppStatus { initializing, unauthenticated, authenticated, lostConnection}

class AppState extends Equatable {
  const AppState({
    required this.user,
    required this.status,
    required this.locale,
  });

  final Locale locale;
  final User? user;
  final AppStatus status;
  AppState copyWith({User? user, AppStatus? status, Locale? locale}) {
    return AppState(
      locale: locale ?? this.locale,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        user,
        status,
        locale,
      ];
}
