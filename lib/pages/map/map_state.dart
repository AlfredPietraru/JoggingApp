part of 'map_cubit.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

final class MapInitial extends MapState {}

final class MapLocationFailed extends MapState {
  final bool serviceEnabled;
  final LocationPermission permission;

  const MapLocationFailed(
      {required this.serviceEnabled, required this.permission});

  MapLocationFailed copyWith(
    bool? serviceEnabled,
    LocationPermission? permission,
  ) {
    return MapLocationFailed(
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      permission: permission ?? this.permission,
    );
  }

  String mapLocationFailedToString() {
    return "$serviceEnabled ${permission.toString()}";
  }

  @override
  List<Object> get props => [serviceEnabled, permission];
}

final class MapLocationSuccesfull extends MapState {
  final bool serviceEnabled;
  final LocationPermission permission;
  final LatLng center;

  const MapLocationSuccesfull({
    required this.center,
    required this.serviceEnabled,
    required this.permission,
  });

  MapLocationSuccesfull copyWith({
    bool? serviceEnabled,
    LocationPermission? permission,
    LatLng? center,
  }) {
    return MapLocationSuccesfull(
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      permission: permission ?? this.permission,
      center: center ?? this.center,
    );
  }

  @override
  List<Object> get props => [serviceEnabled, permission, center];
}

final class MapPositionTracking extends MapState {
  final Position position;
  final LocationPermission permission;

  const MapPositionTracking({required this.permission, required this.position});

  LatLng returnCoordinates() {
    return LatLng(position.latitude, position.longitude);
  }

  @override
  List<Object> get props => [permission, position];
}
