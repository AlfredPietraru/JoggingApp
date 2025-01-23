import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/user.dart';

// scriu coordontate  fisieri
// sa citesc coordontatele din fisier
// sa fac verificarile
class RunSession extends Equatable {
  final DateTime dateTime;
  final List<List<int>> times;
  final List<List<double>> distances;
  final List<List<LatLng>> coordinates;
  final computationClass = FlutterMapMath();

  RunSession({
    required this.coordinates,
    required this.dateTime,
    required this.times,
    required this.distances,
  });

  factory RunSession.initialRunSession(DateTime dateTime) {
    return RunSession(
      // ignore: prefer_const_literals_to_create_immutables
      coordinates: [],
      dateTime: dateTime,
      // ignore: prefer_const_literals_to_create_immutables
      times: [],
      // ignore: prefer_const_literals_to_create_immutables
      distances: [],
    );
  }

  factory RunSession.fromJson(Map<String, dynamic> data) {
    DateTime dt = data['start'].toDate();
    int nrStages = data['noStage'];
    List<List<int>> times = [];
    List<List<double>> distances = [];
    List<List<LatLng>> coordinates = [];
    for (int i = 0; i < nrStages; i++) {
      String info = data['stage_$i'];

      List<int> tempTimes = [];
      List<double> tempDistances = [];
      List<LatLng> tempCoordinates = [];
      List<String> entries = info.split(',');
      for (String entry in entries) {
        List<String> tokens = entry.trim().split(' ');
        if (tokens.length == 4) {
          double distance = double.parse(tokens[0]);
          int time = int.parse(tokens[1]);
          double latitude = double.parse(tokens[2]);
          double longitude = double.parse(tokens[3]);

          tempDistances.add(distance);
          tempTimes.add(time);
          tempCoordinates.add(LatLng(latitude, longitude));
        }
      }

      times.add(tempTimes);
      distances.add(tempDistances);
      coordinates.add(tempCoordinates);
    }

    return RunSession(
      dateTime: dt,
      times: times,
      distances: distances,
      coordinates: coordinates,
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
    );
  }

  int returnDataSize() {
    if (times.length == 1) return times[0].length;
    return times.map((e) => e.length).reduce((a, b) => a + b);
  }

  int returnFromTimeList(int index) {
    if (index >= returnDataSize() || index < 0) return -1;
    for (int i = 0; i < times.length; i++) {
      if (times[i].length <= index) {
        index = index - times[i].length;
      } else {
        return times[i][index];
      }
    }
    return -1;
  }

  double returnFromDistanceList(int index) {
    if (index >= returnDataSize() || index < 0) return -1;
    for (int i = 0; i < distances.length; i++) {
      if (distances[i].length <= index) {
        index = index - distances[i].length;
      } else {
        return distances[i][index];
      }
    }
    return -1;
  }

  void addPositionsToSessions(List<Position> pos) {
    double lastDistance = 0;
    int lastTime = 0;
    if (times.isNotEmpty) {
      lastTime = times.last.last;
      lastDistance = distances.last.last;
    }
    List<double> currentDistances = [lastDistance];
    List<int> currentTimes = [lastTime];
    List<LatLng> currentCoordinates = [
      LatLng(pos[0].latitude, pos[0].longitude)
    ];
    for (int i = 1; i < pos.length; i++) {
      final result = infoFromPositions(pos[i - 1], pos[i]);
      currentDistances.add(currentDistances[i - 1] + result.$1);
      currentTimes.add(currentTimes[i - 1] + result.$2);
      currentCoordinates.add(result.$3);
    }
    times.add(currentTimes);
    distances.add(currentDistances);
    coordinates.add(currentCoordinates);
  }

  (double, int, LatLng) infoFromPositions(Position p1, Position p2) {
    double distance = computationClass.distanceBetween(
        p1.latitude, p1.longitude, p2.latitude, p2.longitude, "meters");
    int time = p2.timestamp.difference(p1.timestamp).inSeconds;
    return (distance, time, LatLng(p2.latitude, p2.longitude));
  }

  String convertOneListToString(int index) {
    if (index < 0 || index >= times.length) return "";
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
      out["stage_${i.toString()}"] = convertOneListToString(i);
    }
    return out;
  }

  String toJsonString() {
    Map<String, dynamic> out = {
      "start": dateTime.toIso8601String(),
      "noStage": distances.length,
    };
    for (int i = 0; i < distances.length; i++) {
      out["stage_${i.toString()}"] = convertOneListToString(i);
    }
    return jsonEncode(out);
  }

  List<(int, double)> createTimeSpeedArray(int chunkSize, int maxSelected) {
    List<(int, double)> out = [(0, 0)];
    Random random = Random(5703);
    int N = returnDataSize();
    int numberChunks = 1;
    if (N % chunkSize == 0) {
      numberChunks = (N / chunkSize).floor();
    } else {
      numberChunks = (N / chunkSize).ceil();
    }

    for (int i = 1; i < numberChunks - 1; i++) {
      Set idxList = {};
      for (int k = 0; k < maxSelected; k++) {
        int currentIdx = i * chunkSize + random.nextInt(chunkSize - 1) + 1; 
        while(idxList.contains(currentIdx)) {
          currentIdx = i * chunkSize + random.nextInt(chunkSize - 1) + 1;
        }
        idxList.add(currentIdx);
      }
      final orderedIdxList = List.from(idxList);
      orderedIdxList.sort();
      for (final index in orderedIdxList) {
        int currentTime = returnFromTimeList(index);
        int previousTime = returnFromTimeList(index - 1);
        if (currentTime == previousTime) continue;
        double currentSpeed = (returnFromDistanceList(index) -
                returnFromDistanceList(index - 1)) /
            (currentTime - previousTime);
        out.add((currentTime, (currentSpeed * 100).round() / 100));
      }
    }
    int finalIndex = -1;
    if (N - (numberChunks - 1) * chunkSize == 1) {
      finalIndex = (numberChunks - 1) * chunkSize;
    } else {
      finalIndex = (numberChunks - 1) * chunkSize +
          random.nextInt(N - (numberChunks - 1) * chunkSize);
    }
    int lastTime = returnFromTimeList(finalIndex);
    int lastPreviousTime = returnFromTimeList(finalIndex - 1);
    if (lastTime == lastPreviousTime) return out;
    double lastSpeed = (returnFromDistanceList(finalIndex) -
            returnFromDistanceList(finalIndex - 1)) /
        (lastTime - lastPreviousTime);
    out.add((lastTime, lastSpeed));
    return out;
  }

  @override
  List<Object?> get props => [dateTime, times, coordinates, distances];
}
