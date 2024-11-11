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
    emit(MapLocationSuccesfull(
      center: LatLng(currentPosition.latitude, currentPosition.longitude),
      permission: permission,
      serviceEnabled: serviceEnabled,
    ));
  }
}
