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

  void initialise() {
    emit(const MapLocationRequested(
        serviceEnabled: false,
        permission: LocationPermission.unableToDetermine,
        center: LatLng(0, 0)));
    
  }
}
