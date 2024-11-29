import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/run_session.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.userRepository, required this.runSession})
      : super(const MapInitial(
            initialLocation: LatLng(4, 4),
            serviceEnabled: false,
            permission: LocationPermission.unableToDetermine)) {
    initialise();
  }

  late StreamSubscription<Position> _positionStreamSubscription;
  int stageSize = 100;
  final UserRepository userRepository;
  RunSession runSession;
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
      center: currentPosition,
      positions: const [],
      status: MapStatus.ready,
      enableButton: true,
    ));
    initialLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);
  }

  Future<void> startTrackingLocation() async {
    final currentState = state;
    if (currentState is! MapTrack) return;
    if (currentState.status != MapStatus.ready) return;

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      final oldState = state as MapTrack;
      if (oldState.status != MapStatus.tracking) return;
      if (oldState.positions.length < stageSize) {
        emit(oldState.copyWith(
          center: position,
          positions: [...oldState.positions, position],
        ));
      } else {
        runSession.addPositionsToSessions(oldState.positions);
        emit(
          oldState.copyWith(
            center: position,
            positions: [position],
          ),
        );
      }
    });

    emit(
      currentState.copyWith(
        positions: [currentState.center],
        status: MapStatus.tracking,
        enableButton: true,
      ),
    );
  }

  void stopTrackingLocation() {
    final oldState = state as MapTrack;
    _positionStreamSubscription.cancel();
    if (oldState.status != MapStatus.tracking) return;
    emit(oldState.copyWith(status: MapStatus.sending));
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
    emit(oldState.copyWith(positions: [], status: MapStatus.ready));
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
