part of 'map_cubit.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

final class MapInitial extends MapState {}

final class MapLocationRequested extends MapState {
  final bool serviceEnabled;
  final LocationPermission permission;
  final LatLng center;

  const MapLocationRequested(
      {required this.serviceEnabled,
      required this.permission,
      required this.center});

  MapLocationRequested copyWith(
    bool? serviceEnabled,
    LocationPermission? permission,
    LatLng? center,
  ) {
    return MapLocationRequested(
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      permission: permission ?? this.permission,
      center: center ?? this.center,
    );
  }

  @override
  List<Object> get props => [serviceEnabled, permission, center];
}
