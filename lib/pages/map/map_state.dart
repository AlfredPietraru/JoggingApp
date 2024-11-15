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
  final LatLng center;

  const MapLocationSuccesfull({
    required this.center,
    required this.serviceEnabled,
  });

  MapLocationSuccesfull copyWith({
    bool? serviceEnabled,
    LocationPermission? permission,
    LatLng? center,
  }) {
    return MapLocationSuccesfull(
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      center: center ?? this.center,
    );
  }

  @override
  List<Object> get props => [serviceEnabled, center];
}

final class MapPositionTracking extends MapState {
  final Position position;
  final int numberHalfHourPassed;
  final int numberPositionsReceived;

  const MapPositionTracking({
    required this.numberHalfHourPassed,
    required this.position,
    required this.numberPositionsReceived,
  });

  factory MapPositionTracking.fromCoordinates(
      {required double latitude, required double longitude}) {
    return MapPositionTracking(
      position: Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      ),
      numberHalfHourPassed: 0,
      numberPositionsReceived: 0,
    );
  }

  MapPositionTracking copyWith({
    Position? position,
    int? numberHalfHourPassed,
    int? numberPositionsReceived,
  }) {
    return MapPositionTracking(
        numberPositionsReceived:
            numberPositionsReceived ?? this.numberPositionsReceived,
        position: position ?? this.position,
        numberHalfHourPassed:
            numberHalfHourPassed ?? this.numberHalfHourPassed);
  }

  LatLng returnCoordinates() {
    return LatLng(position.latitude, position.longitude);
  }

  @override
  List<Object> get props =>
      [position, numberHalfHourPassed, numberPositionsReceived];
}
