import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/auth/user.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required this.userRepository})
      : super(const ExploreState(name: "", userId: []));

  final UserRepository userRepository;
  void getInfoFromServer() {
    // userRepository.getUserFromDatabase(id)
  }
}
