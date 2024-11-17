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

final class MapLocationSuccesfull extends MapState {
  final Position center;
  final List<Position> positions;
  final int noStage;

  const MapLocationSuccesfull({
    required this.noStage,
    required this.positions,
    required this.center,
  });

  LatLng returnCoordinates() {
    return LatLng(center.latitude, center.longitude);
  }

  MapLocationSuccesfull copyWith({
    Position? center,
    List<Position>? positions,
    int? noStage,
  }) {
    return MapLocationSuccesfull(
      noStage: noStage ?? this.noStage,
      center: center ?? this.center,
      positions: positions ?? this.positions,
    );
  }

  String convertPositionsListToString() {
    final computationClass = FlutterMapMath();
    List<String> outData = [
      "${0.0.toString()}/${positions[0].timestamp.toString()}"
    ];
    double distance = 0.0;
    for (int i = 1; i < positions.length; i++) {
      distance = computationClass.distanceBetween(
          positions[i - 1].latitude,
          positions[i - 1].longitude,
          positions[i].latitude,
          positions[i].longitude,
          "meters");
      outData.add(
          "${distance.toStringAsFixed(2)}/${positions[i].timestamp.toString()}");
    }
    return outData.reduce((value, element) => "$value,$element");
  }

  @override
  List<Object> get props => [center, positions, noStage];
}

final class MapPositionTrack extends MapState {
  final List<Position> positions;
  final int noStage;
  final int noPositions;

  const MapPositionTrack({
    required this.noStage,
    required this.positions,
    required this.noPositions,
  });

  MapPositionTrack copyWith({
    List<Position>? positions,
    int? noStage,
    int? noPositions,
  }) {
    return MapPositionTrack(
      noPositions: noPositions ?? this.noPositions,
      noStage: noStage ?? this.noStage,
      positions: positions ?? this.positions,
    );
  }

  LatLng returnCoordinates() {
    return LatLng(positions.last.latitude, positions.last.longitude);
  }

  @override
  List<Object> get props => [noStage, noPositions];
}
