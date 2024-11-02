import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/repository.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({required this.userRepository}) : super(MapInitial());

  final UserRepository userRepository;
}
