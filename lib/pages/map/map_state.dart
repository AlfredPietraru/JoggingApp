part of 'map_cubit.dart';

sealed class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

final class MapInitial extends MapState {
  final bool serviceEnabled;
  final LocationPermission permission;
  final LatLng initialLocation;

  const MapInitial(
      {required this.initialLocation,
      required this.serviceEnabled,
      required this.permission});

  MapInitial copyWith({
    bool? serviceEnabled,
    LocationPermission? permission,
    LatLng? initialLocation,
  }) {
    return MapInitial(
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      permission: permission ?? this.permission,
      initialLocation: initialLocation ?? this.initialLocation,
    );
  }

  String mapLocationFailedToString() {
    return "$serviceEnabled ${permission.toString()}";
  }

  @override
  List<Object> get props => [serviceEnabled, permission, initialLocation];
}

enum MapStatus { ready, tracking, sending, blocked }

final class MapTrack extends MapState {
  final Position center;
  final List<Position> positions;
  final MapStatus status;
  final bool enableButton;

  const MapTrack({
    required this.enableButton,
    required this.center,
    required this.positions,
    required this.status,
  });

  MapTrack copyWith({
    Position? center,
    List<Position>? positions,
    MapStatus? status,
    bool? enableButton,
  }) {
    return MapTrack(
      status: status ?? this.status,
      center: center ?? this.center,
      positions: positions ?? this.positions,
      enableButton: enableButton ?? this.enableButton,
    );
  }

  LatLng returnCoordinates() {
    return LatLng(center.latitude, center.longitude);
  }

  @override
  List<Object> get props => [status, center, positions];
}
