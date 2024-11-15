import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jogging/auth/user.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.user})
      : super(SettingsInitial(
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
    emit((state as SettingsInitial).copyWith(firstName: firstName));
  }

  void changeLastName(String lastName) {
    emit((state as SettingsInitial).copyWith(lastName: lastName));
  }

  void changeAge(int age) {
    emit((state as SettingsInitial).copyWith(age: age));
  }

  void changeSex(String? sex) {
    emit((state as SettingsInitial).copyWith(sex: Sex.fromName(sex!)));
  }

  void toggleEditFirstName() {
    emit((state as SettingsInitial)
        .copyWith(editFirstName: !(state as SettingsInitial).editFirstName));
  }

  void toggleEditLastName() {
    emit((state as SettingsInitial)
        .copyWith(editLastName: !(state as SettingsInitial).editLastName));
  }

  void toggleEditSex() {
    emit((state as SettingsInitial)
        .copyWith(editSex: !(state as SettingsInitial).editSex));
  }

  void toggleEditAge() {
    emit((state as SettingsInitial)
        .copyWith(editAge: !(state as SettingsInitial).editAge));
  }

  bool applyChanges() {
    final oldState = state as SettingsInitial;
    print(user);
    if (user.firstName != oldState.firstName) return true;
    if (user.lastName != oldState.lastName) return true;
    if (user.age != oldState.age) return true;
    if (user.sex != oldState.sex) return true;
    return false;
  }
}
