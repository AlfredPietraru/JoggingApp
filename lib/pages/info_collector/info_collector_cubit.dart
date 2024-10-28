import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/pages/info_collector/info_collector_state.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/auth/repository.dart';

class InfoCollectorCubit extends Cubit<InfoCollectorState> {
  InfoCollectorCubit({required this.userRepository})
      : super(InfoCollectorInitialState());
  final UserRepository userRepository;

  bool _nameIsValid(String name) {
    if (name == "") return false;
    if (name.length < 3) return false;
    final nameRegExp = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ' -]{2,50}$");
    return nameRegExp.hasMatch(name);
  }

  Future<bool> completeUserInfo(
      String firstName, String lastName, Sex sex, int age) async {
    if (!_nameIsValid(firstName)) {
      emit(InfoCollectorWrongFirstNameState());
      return false;
    }
    if (!_nameIsValid(lastName)) {
      emit(InfoCollectorWrongLastNameState());
      return false;
    }
    final output = await userRepository.createUser(
        firstName: firstName, lastName: lastName, age: age, sex: sex);
    if (output == null) return true;
    emit(InfoCollectorNoInternetState());
    return false;
  }
}
