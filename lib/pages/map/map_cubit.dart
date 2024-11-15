import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/user.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.userRepository, required this.user})
      : super(MapInitial()) {
    initialise();
  }

  int updatePeriod = 1;
  late bool serviceEnabled;
  late LocationPermission permission;
  final User user;
  final UserRepository userRepository;
  List<Position> positionsList = [];
  Timer? timer;
  late LatLng initialMapLocation;

  void initialise() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(MapLocationFailed(
          serviceEnabled: serviceEnabled,
          permission: LocationPermission.unableToDetermine));
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      emit(MapLocationFailed(
        serviceEnabled: serviceEnabled,
        permission: permission,
      ));
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        emit(MapLocationFailed(
          serviceEnabled: serviceEnabled,
          permission: permission,
        ));
        return;
      }
    }
    Position currentPosition = await Geolocator.getCurrentPosition();
    emit(
      MapLocationSuccesfull(
        center: LatLng(currentPosition.latitude, currentPosition.longitude),
        serviceEnabled: serviceEnabled,
      ),
    );
    initialMapLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  void startTrackingLocation() async {
    if (state is! MapLocationSuccesfull) return;
    if (timer != null) return;
    final oldState = state as MapLocationSuccesfull;
    _displayFakeMeasurement(oldState);
    Position position = await Geolocator.getCurrentPosition();
    positionsList.add(position);
    emit(
      MapPositionTracking(
          position: position,
          numberHalfHourPassed: 0,
          numberPositionsReceived: 0),
    );

    timer = Timer.periodic(
      Duration(seconds: updatePeriod),
      (Timer t) async {
        Position position = await Geolocator.getCurrentPosition();
        positionsList.add(position);
        if (state is MapPositionTracking) {
          final oldState = state as MapPositionTracking;
          emit(oldState.copyWith(
            position: position,
            numberPositionsReceived: oldState.numberPositionsReceived + 1,
          ));
        }
        if (state is MapLocationSuccesfull) {
          emit(
            MapPositionTracking(
                position: position,
                numberHalfHourPassed: 0,
                numberPositionsReceived: 0),
          );
        }
      },
    );
  }

  void stopTrackingLocation() {
    if (state is! MapPositionTracking) return;
    timer?.cancel();
    timer = null;
    final oldState = state as MapPositionTracking;
    Future.delayed(Duration(seconds: updatePeriod), () {
      emit(
        MapLocationSuccesfull(
          center: oldState.returnCoordinates(),
          serviceEnabled: true,
        ),
      );
    });
    emit(
      MapLocationSuccesfull(
        center: oldState.returnCoordinates(),
        serviceEnabled: true,
      ),
    );
    
    Future.delayed(Duration.zero, () async {
      await userRepository.writePositionsToDatabase(
          _convertPositionsListToString(), user);
      positionsList = [];
    });
  }

  void _displayFakeMeasurement(MapLocationSuccesfull oldState) {
    emit(MapPositionTracking.fromCoordinates(
      latitude: oldState.center.latitude,
      longitude: oldState.center.longitude,
    ));
  }

  String _convertPositionsListToString() {
    final computationClass = FlutterMapMath();
    List<String> outData = [
      "(${0.0.toString()}/${positionsList[0].timestamp.toString()}"
    ];
    double distance = 0.0;
    for (int i = 1; i < positionsList.length; i++) {
      distance = computationClass.distanceBetween(
          positionsList[i - 1].latitude,
          positionsList[i - 1].longitude,
          positionsList[i].latitude,
          positionsList[i].longitude,
          "meters");
      outData.add(
          "(${distance.toStringAsFixed(2)}/${positionsList[i].timestamp.toString()}");
    }
    return outData.reduce((value, element) => "$value,$element");
  }
}
