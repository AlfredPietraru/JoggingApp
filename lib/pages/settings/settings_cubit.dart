import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/user.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.user})
      : super(SettingsState(
          applyChanges: false,
          age: user.age,
          firstName: user.firstName,
          lastName: user.lastName,
          sex: user.sex,
          editFirstName: false,
          editLastName: false,
          editSex: false,
          editAge: false,
        ));

  final User user;

  void changeFirstName(String firstName) {
    emit(state.copyWith(firstName: firstName));
  }

  void changeLastName(String lastName) {
    emit(state.copyWith(lastName: lastName));
  }

  void changeAge(int age) {
    emit(state.copyWith(age: age));
  }

  void changeSex(String? sex) {
    emit(state.copyWith(sex: Sex.fromName(sex!)));
  }

  void toggleEditFirstName() {
    emit(state.copyWith(editFirstName: !state.editFirstName));
  }

  void toggleEditLastName() {
    emit(state.copyWith(editLastName: !state.editLastName));
  }

  void toggleEditSex() {
    emit(state.copyWith(editSex: !state.editSex));
  }

  void toggleEditAge() {
    emit(state.copyWith(editAge: !state.editAge));
  }

  bool applyChanges() {
    if (user.firstName != state.firstName) return true;
    if (user.lastName != state.lastName) return true;
    if (user.age != state.age) return true;
    if (user.sex != state.sex) return true;
    return false;
  }
}
