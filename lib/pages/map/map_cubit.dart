import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/runSession.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.userRepository, required this.runSession})
      : super(const MapInitial(
            initialLocation: LatLng(4, 4),
            serviceEnabled: false,
            permission: LocationPermission.unableToDetermine)) {
    initialise();
  }

  int updatePeriod = 1;
  int stageSize = 20;
  final UserRepository userRepository;
  RunSession runSession;
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
    runSession = runSession.copyWith(dateTime: DateTime.now());
    emit(MapTrack(
        center: position, positions: [position], status: MapStatus.tracking));

    timer = Timer.periodic(
      Duration(seconds: updatePeriod),
      (Timer t) async {
        final oldState = state as MapTrack;
        if (oldState.status != MapStatus.tracking) return;
        if (oldState.positions.length > stageSize) return;
        Position position = await Geolocator.getCurrentPosition();
        oldState.positions.add(position);
        if (oldState.positions.length == stageSize) {
          runSession.addPositionsToSessions(oldState.positions);
          emit(oldState.copyWith(
            center: position,
            positions: [position],
          ));
          return;
        }
        if (oldState.positions.length < stageSize) {
          emit(oldState.copyWith(center: position));
          return;
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
    Future.delayed(const Duration(seconds: 5), () {
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

  void sendRunToDatabase() async {
    final oldState = state as MapTrack;
    if (oldState.status != MapStatus.sending) return;
    runSession.addPositionsToSessions(oldState.positions);
    await userRepository.writePositionsToDatabase(runSession);
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
