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
      : super(const MapInitial(
            initialLocation: LatLng(4, 4),
            serviceEnabled: false,
            permission: LocationPermission.unableToDetermine)) {
    initialise();
  }

  int updatePeriod = 1;
  late bool serviceEnabled;
  late LocationPermission permission;
  final User user;
  final UserRepository userRepository;
  Timer? timer;
  late LatLng initialLocation;

  void initialise() async {
    if (state is! MapInitial) return;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    final oldState = state as MapInitial;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      emit(oldState.copyWith(serviceEnabled: true, permission: permission));
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        emit(oldState.copyWith(serviceEnabled: true, permission: permission));
        return;
      }
    }
    Position currentPosition = await Geolocator.getCurrentPosition();
    emit(MapLocationSuccesfull(
        center: currentPosition, positions: const [], noStage: 0));
    initialLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  void startTrackingLocation() async {
    if (state is! MapLocationSuccesfull) return;
    if (timer != null) return;
    Position pos = (state as MapLocationSuccesfull).center;
    emit(MapPositionTrack(positions: [pos], noStage: 0, noPositions: 1));
    Position position = await Geolocator.getCurrentPosition();
    final oldState = state as MapPositionTrack;
    oldState.positions.add(position);
    emit(oldState.copyWith(noPositions: oldState.noPositions + 1));

    timer = Timer.periodic(
      Duration(seconds: updatePeriod),
      (Timer t) async {
        if (state is MapLocationSuccesfull) return;
        final oldState = state as MapPositionTrack;
        Position position = await Geolocator.getCurrentPosition();
        oldState.positions.add(position);
        emit(oldState.copyWith(noPositions: oldState.noPositions + 1));
      },
    );
  }

  void stopTrackingLocation() {
    if (state is! MapPositionTrack) return;
    timer?.cancel();
    timer = null;
    final oldState = state as MapPositionTrack;
    emit(MapLocationSuccesfull(
        center: oldState.positions.last,
        positions: oldState.positions,
        noStage: oldState.noStage));

    Future.delayed(
      const Duration(seconds: 1),
      () async {
        final oldState = state as MapLocationSuccesfull;
        await userRepository.writePositionsToDatabase(
            oldState.convertPositionsListToString(), user, 0);
        emit(oldState.copyWith(positions: []));
      },
    );
  }

  LatLng setMapCenter() {
    final oldState = state;
    return switch (oldState) {
      MapInitial() => oldState.initialLocation,
      MapLocationSuccesfull() => oldState.returnCoordinates(),
      MapPositionTrack() => oldState.returnCoordinates(),
    };
  }
}
