import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/user.dart';

class RunRepository {
  final User user;
  int noStage = 0;
  late Position initialPosition;
  List<String> stages = [];
  final computationClass = FlutterMapMath();
  late DateTime dateTime;

  RunRepository({required this.user});

  void resetRunRepository(
    DateTime dateTime,
    Position initialPosition,
  ) {
    stages = [];
    noStage = 0;
    this.dateTime = dateTime;
    this.initialPosition = initialPosition;
  }

  void setDate(DateTime dateTime) {
    this.dateTime = dateTime;
  }

  void convertPositionsListToString(List<Position> positions) {
    List<String> outData = ["${0.0.toString()}/${0.toString()}"];
    double distance = 0.0;
    late Duration time;
    for (int i = 1; i < positions.length; i++) {
      distance = computationClass.distanceBetween(
          positions[i - 1].latitude,
          positions[i - 1].longitude,
          positions[i].latitude,
          positions[i].longitude,
          "meters");
      time = positions[i].timestamp.difference(positions[i - 1].timestamp);
      outData.add(
          "${distance.toStringAsFixed(2)}/${time.inMilliseconds.toString()}");
    }
    stages.add(outData.reduce((value, element) => "$value,$element"));
    noStage += 1;
  }

  Map<String, dynamic> convertToDatabaseOut() {
    Map<String, dynamic> out = {
      "initialLocation":
          LatLng(initialPosition.latitude, initialPosition.longitude)
              .toString(),
      "start": dateTime.toString(),
      "noStage": noStage
    };
    for (int i = 0; i < noStage; i++) {
      out["stage_${i.toString()}"] = stages[i];
    }
    return out;
  }
}
