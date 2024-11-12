import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/repository.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.userRepository}) : super(MapInitial()) {
    initialise();
  }

  final UserRepository userRepository;
  List<Position> positionsList = [];
  Timer? timer;

  void initialise() async {
    bool serviceEnabled;
    LocationPermission permission;
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
        permission: permission,
        serviceEnabled: serviceEnabled,
      ),
    );
  }

  void startTrackingLocation() async {
    if (state is! MapLocationSuccesfull) return;
    if (timer != null) return;
    final oldState = state as MapLocationSuccesfull;
    _displayFakeMeasurement(oldState);
    Position position = await Geolocator.getCurrentPosition();
    positionsList.add(position);
    emit(
      MapPositionTracking(position: position, permission: oldState.permission),
    );
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer t) async {
        Position position = await Geolocator.getCurrentPosition();
        positionsList.add(position);
        emit(
          MapPositionTracking(
              position: position, permission: oldState.permission),
        );
      },
    );
  }

  void stopTrackingLocation() {
    if (state is! MapPositionTracking) return;
    timer?.cancel();
    timer = null;
    final oldState = state as MapPositionTracking;
    Future.delayed(const Duration(seconds: 2), () {
      emit(
        MapLocationSuccesfull(
          center: oldState.returnCoordinates(),
          permission: oldState.permission,
          serviceEnabled: true,
        ),
      );
    });
    emit(
      MapLocationSuccesfull(
        center: oldState.returnCoordinates(),
        permission: oldState.permission,
        serviceEnabled: true,
      ),
    );
    print(positionsList);
    positionsList = [];
  }

  void _displayFakeMeasurement(MapLocationSuccesfull oldState) {
    emit(
      MapPositionTracking(
          position: Position(
            latitude: oldState.center.latitude,
            longitude: oldState.center.longitude,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          ),
          permission: oldState.permission),
    );
  }
}
