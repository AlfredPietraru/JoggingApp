import 'dart:core';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/user.dart';

class RunSession {
  final DateTime dateTime;
  List<List<double>> times;
  List<List<double>> distances;
  List<List<LatLng>> coordinates;
  final computationClass = FlutterMapMath();
  final User user;

  RunSession({
    required this.coordinates,
    required this.user,
    required this.dateTime,
    required this.times,
    required this.distances,
  });

  RunSession copyWith({
    List<List<LatLng>>? coordinates,
    DateTime? dateTime,
    List<List<double>>? times,
    List<List<double>>? distances,
    User? user,
  }) {
    return RunSession(
      coordinates: coordinates ?? this.coordinates,
      dateTime: dateTime ?? this.dateTime,
      times: times ?? this.times,
      distances: distances ?? this.distances,
      user: user ?? this.user,
    );
  }

  void addPositionsToSessions(List<Position> pos) {
    List<double> currentDistances = [0.0];
    List<double> currentTimes = [0.0];
    List<LatLng> currentCoordinates = [
      LatLng(pos[0].latitude, pos[0].longitude)
    ];
    for (int i = 1; i < pos.length; i++) {
      final result = infoFromPositions(pos[i - 1], pos[i]);
      currentDistances.add(result.$1);
      currentTimes.add(result.$2);
      currentCoordinates.add(result.$3);
    }
    times.add(currentTimes);
    distances.add(currentDistances);
    coordinates.add(currentCoordinates);
  }

  (double, double, LatLng) infoFromPositions(Position p1, Position p2) {
    double distance = computationClass.distanceBetween(
        p1.latitude, p1.longitude, p2.latitude, p2.longitude, "meters");
    double time =
        p2.timestamp.difference(p1.timestamp).inMilliseconds.toDouble();
    return (distance, time, LatLng(p2.latitude, p2.longitude));
  }

  // "${distance.toStringAsFixed(2)}/${time.inMilliseconds.toString()}/${p2.latitude}/${p2.longitude}";

  // void convertPositionsListToString(List<Position> positions) {
  //   Position first = positions.first;
  //   List<String> outData = [
  //     "${0.0.toString()}/${0.toString()}/${first.latitude}/${first.longitude}"
  //   ];
  //   for (int i = 1; i < positions.length; i++) {
  //     outData.add(_computeInfoSave(positions[i - 1], positions[i]));
  //   }
  //   // stages.add(outData.reduce((value, element) => "$value,$element"));
  // }

  String _convertOneListToString(int index) {
    final List<double> currentTimes = times[index];
    final List<double> currentDistances = distances[index];
    final List<LatLng> currentCoordinates = coordinates[index];
    final List<String> toStringValues = [];
    for (int i = 0; i < currentTimes.length; i++) {
      toStringValues.add(
          "${currentDistances[i].toStringAsFixed(2)}/${currentTimes[i]}${currentCoordinates[i].latitude}/${currentCoordinates[i].longitude}");
    }
    return toStringValues.reduce((value, element) => "$value,$element");
  }

  Map<String, dynamic> convertToDatabaseOut() {
    Map<String, dynamic> out = {
      "start": dateTime.toString(),
      "noStage": distances.length,
    };
    for (int i = 0; i < distances.length; i++) {
      out["stage_${i.toString()}"] = _convertOneListToString(i);
    }
    return out;
  }
}
