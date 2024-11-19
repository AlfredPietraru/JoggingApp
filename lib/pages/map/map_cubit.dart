import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/pages/map/run_repository.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.userRepository, required this.runRepository})
      : super(const MapInitial(
            initialLocation: LatLng(4, 4),
            serviceEnabled: false,
            permission: LocationPermission.unableToDetermine)) {
    initialise();
  }

  int updatePeriod = 1;
  int stageSize = 60;
  final UserRepository userRepository;
  RunRepository runRepository;
  Timer? timer;
  late LatLng initialLocation;

  void initialise() async {
    late bool serviceEnabled;
    late LocationPermission permission;
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
    emit(MapTrack(
        center: currentPosition, positions: const [], status: MapStatus.ready));
    initialLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  void startTrackingLocation() async {
    final oldState = state as MapTrack;
    if (oldState.status != MapStatus.ready || timer != null) return;
    emit(oldState.copyWith(
        positions: [oldState.center], nrStage: 0, status: MapStatus.tracking));
    Position position = await Geolocator.getCurrentPosition();
    runRepository = runRepository.copyWith(dateTime: DateTime.now());
    emit(MapTrack(
        center: position, positions: [position], status: MapStatus.tracking));

    timer = Timer.periodic(
      Duration(seconds: updatePeriod),
      (Timer t) async {
        final oldState = state as MapTrack;
        if (oldState.status != MapStatus.tracking) return;
        Position position = await Geolocator.getCurrentPosition();
        oldState.positions.add(position);
        if (oldState.positions.length >= 60) {
          runRepository.convertPositionsListToString(oldState.positions);
          emit(oldState.copyWith(
            center: position,
            positions: [position],
          ));
        } else {
          emit(oldState.copyWith(center: position));
        }
      },
    );
  }

  void stopTrackingLocation() {
    timer?.cancel();
    timer = null;
    final oldState = state as MapTrack;
    if (oldState.status != MapStatus.tracking) return;
    emit(oldState.copyWith(status: MapStatus.blocked));
    Future.delayed(Duration(seconds: updatePeriod * 2), () {
      emit(oldState.copyWith(status: MapStatus.sending));
    });
  }

  LatLng setMapCenter() {
    final oldState = state;
    return switch (oldState) {
      MapTrack() => oldState.returnCoordinates(),
      MapInitial() => oldState.initialLocation,
    };
  }

  void sendRunToDatabase(User user) async {
    runRepository = runRepository.copyWith(user: user);
    final oldState = state as MapTrack;
    if (oldState.status != MapStatus.sending) return;
    runRepository.convertPositionsListToString(oldState.positions);
    await userRepository.writePositionsToDatabase(
      runRepository,
    );
    emit(oldState.copyWith(positions: [], nrStage: 0, status: MapStatus.ready));
  }

  String displayButtonInfo() {
    return switch (state) {
      MapInitial() => 'No location found',
      MapTrack() => switch ((state as MapTrack).status) {
          MapStatus.ready => 'Start Tracking',
          MapStatus.tracking => 'Stop Tracking',
          MapStatus.sending => 'Sending info',
          MapStatus.blocked => 'Start Tracking'
        },
    };
  }
}
