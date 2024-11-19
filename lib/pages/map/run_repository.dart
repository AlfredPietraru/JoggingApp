import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jogging/auth/user.dart';

class RunRepository {
  final User user;
  final List<String> stages;
  final computationClass = FlutterMapMath();
  final DateTime dateTime;

  RunRepository({
    required this.user,
    required this.dateTime,
    required this.stages,
  });

  RunRepository copyWith({
    User? user,
    DateTime? dateTime,
    List<String>? stages,
  }) {
    return RunRepository(
        user: user ?? this.user,
        dateTime: dateTime ?? this.dateTime,
        stages: stages ?? this.stages);
  }

  String _computeInfoSave(Position p1, Position p2) {
    double distance = computationClass.distanceBetween(
        p1.latitude, p1.longitude, p2.latitude, p2.longitude, "meters");
    Duration time = p2.timestamp.difference(p1.timestamp);
    return "${distance.toStringAsFixed(2)}/${time.inMilliseconds.toString()}/${p2.latitude}/${p2.longitude}";
  }

  void convertPositionsListToString(List<Position> positions) {
    Position first = positions.first;
    List<String> outData = [
      "${0.0.toString()}/${0.toString()}/${first.latitude}/${first.longitude}"
    ];
    for (int i = 1; i < positions.length; i++) {
      outData.add(_computeInfoSave(positions[i - 1], positions[i]));
    }
    stages.add(outData.reduce((value, element) => "$value,$element"));
  }

  Map<String, dynamic> convertToDatabaseOut() {
    Map<String, dynamic> out = {
      "start": dateTime.toString(),
      "noStage": stages.length,
    };
    for (int i = 0; i < stages.length; i++) {
      out["stage_${i.toString()}"] = stages[i];
    }
    return out;
  }
}
