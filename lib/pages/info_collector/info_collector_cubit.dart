import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jogging/auth/failures.dart';
import 'package:jogging/pages/info_collector/info_collector_state.dart';
import 'package:jogging/auth/user.dart';
import 'package:jogging/auth/repository.dart';

class InfoCollectorCubit extends Cubit<InfoCollectorState> {
  InfoCollectorCubit({
    required this.email,
    required this.password,
    required this.userRepository,
  }) : super(
          InfoCollectorInitialState(
            description: "Hello, I am using Jogging Time.",
            email: email,
            password: password,
            sex: Sex.other,
            age: 18,
            firstName: '',
            lastName: '',
            failure: CreateUserFailure.noFailureAtAll,
            stopFromClicking: false,
          ),
        );

  final UserRepository userRepository;
  final String email;
  final String password;

  void changeFirstName(String firstName) {
    emit(
      (state as InfoCollectorInitialState).copyWith(
        firstName: firstName,
        failure: _isNameValid(firstName)
            ? CreateUserFailure.noFailureAtAll
            : CreateUserFailure.invalidFirstName,
      ),
    );
  }

  void changeDescription(String description) {
    emit(
      (state as InfoCollectorInitialState).copyWith(
        description: description,
        failure: _isDescriptionValid(description)
            ? CreateUserFailure.noFailureAtAll
            : CreateUserFailure.invalidDescription,
      ),
    );
  }

  void changeLastName(String lastName) {
    emit((state as InfoCollectorInitialState).copyWith(
        lastName: lastName,
        failure: _isNameValid(lastName)
            ? CreateUserFailure.noFailureAtAll
            : CreateUserFailure.invalidLastName));
  }

  void changeAgeValue(int age) {
    emit((state as InfoCollectorInitialState).copyWith(age: age));
  }

  void changeSexValue(String? sex) {
    if (sex == null) {
      emit((state as InfoCollectorInitialState).copyWith(sex: Sex.other));
      return;
    }
    emit((state as InfoCollectorInitialState).copyWith(sex: Sex.fromName(sex)));
  }

  void createUser() async {
    final oldState = state as InfoCollectorInitialState;
    emit((state as InfoCollectorInitialState).copyWith(stopFromClicking: true));
    final result = await userRepository.createUser(
      email: email,
      password: password,
      firstName: oldState.firstName,
      lastName: oldState.lastName,
      age: oldState.age,
      sex: oldState.sex,
      description: oldState.description,
    );
    result.fold((l) {
      emit((state as InfoCollectorInitialState)
          .copyWith(failure: l, stopFromClicking: false));
    }, (r) {
      emit(InfoCollectorSuccessState(user: r));
    });
  }

  bool _isNameValid(String name) {
    if (name == "") return false;
    RegExp nameRegExp = RegExp(r"^[a-zA-Z]+([ '-][a-zA-Z]+)*$");
    return nameRegExp.hasMatch(name);
  }

  bool _isDescriptionValid(String description) {
    if (description.length < 160) return true;
    return false;
  }
}
