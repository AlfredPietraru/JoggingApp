import 'package:bloc/bloc.dart';
import 'package:jogging/auth/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/repository.dart';
import 'package:jogging/pages/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.userRepository, required User user})
      : super(ProfileState(
          image: "${user.uid}/images/profile.png",
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

  final UserRepository userRepository;

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

  User updateUser(User user) {
    final newUser = user.copyWith(
      firstName: state.firstName,
      lastName: state.lastName,
      age: state.age,
      sex: state.sex,
    );
    userRepository.updateUserInformation(newUser);
    return newUser;
  }

  Future<void> requestPhoto(String uid) async {
    return;
  }

  Future<void> choosePhoto(String uid) async {}

  bool shouldApplyChanges(User user) {
    if (user.firstName != state.firstName) return true;
    if (user.lastName != state.lastName) return true;
    if (user.age != state.age) return true;
    if (user.sex != state.sex) return true;
    return false;
  }
}
