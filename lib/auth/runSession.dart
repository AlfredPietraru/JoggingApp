import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/user.dart';

class RunSession extends Equatable {
  final DateTime dateTime;
  final List<List<int>> times;
  final List<List<double>> distances;
  final List<List<LatLng>> coordinates;
  final computationClass = FlutterMapMath();
  final User user;

  RunSession({
    required this.coordinates,
    required this.user,
    required this.dateTime,
    required this.times,
    required this.distances,
  });

  factory RunSession.initialRunSession(User user, DateTime dateTime) {
    return RunSession(
      coordinates: [],
      user: user,
      dateTime: dateTime,
      times: [],
      distances: [],
    );
  }

  factory RunSession.fromJson(Map<String, dynamic> data, User user) {
    DateTime dt = (data['start'] as Timestamp).toDate();
    int nrStages = data["noStage"];
    List<List<LatLng>> coordinates = [];
    List<List<int>> times = [];
    List<List<double>> distances = [];
    for (int i = 0; i < nrStages; i++) {
      String info = data["stage_${i.toString()}"];
      List<double> dist = [];
      List<int> temp = [];
      List<LatLng> coord = [];
      List<String> splittedInfo = info.split(',');
      for (String elem in splittedInfo) {
        List<String> tokens = elem.split(' ');
        dist.add(double.parse(tokens[0]));
        temp.add(int.parse(tokens[1]));
        coord.add(LatLng(double.parse(tokens[2]), double.parse(tokens[3])));
      }
      times.add(temp);
      distances.add(dist);
      coordinates.add(coord);
    }
    return RunSession(
      coordinates: coordinates,
      user: user,
      dateTime: dt,
      times: times,
      distances: distances,
    );
  }

  RunSession copyWith({
    List<List<LatLng>>? coordinates,
    DateTime? dateTime,
    List<List<int>>? times,
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
    List<int> currentTimes = [0];
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

  (double, int, LatLng) infoFromPositions(Position p1, Position p2) {
    double distance = computationClass.distanceBetween(
        p1.latitude, p1.longitude, p2.latitude, p2.longitude, "meters");
    int time = p2.timestamp.difference(p1.timestamp).inMilliseconds;
    return (distance, time, LatLng(p2.latitude, p2.longitude));
  }

  String _convertOneListToString(int index) {
    final List<int> currentTimes = times[index];
    final List<double> currentDistances = distances[index];
    final List<LatLng> currentCoordinates = coordinates[index];
    final List<String> toStringValues = [];
    for (int i = 0; i < currentTimes.length; i++) {
      toStringValues.add(
          "${currentDistances[i].toStringAsFixed(2)} ${currentTimes[i]} ${currentCoordinates[i].latitude} ${currentCoordinates[i].longitude} ");
    }
    return toStringValues.reduce((value, element) => "$value,$element");
  }

  Map<String, dynamic> convertToDatabaseOut() {
    Map<String, dynamic> out = {
      "start": dateTime,
      "noStage": distances.length,
    };
    for (int i = 0; i < distances.length; i++) {
      out["stage_${i.toString()}"] = _convertOneListToString(i);
    }
    return out;
  }

  @override
  List<Object?> get props => [dateTime, times, coordinates, distances, user];
}
