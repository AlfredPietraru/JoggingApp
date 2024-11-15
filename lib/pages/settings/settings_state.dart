part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {
  final String firstName;
  final String lastName;
  final int age;
  final Sex sex;
  final bool editFirstName;
  final bool editLastName;
  final bool editSex;
  final bool editAge;
  final bool applyChanges;

  const SettingsInitial(
      {required this.editFirstName,
      required this.editLastName,
      required this.editSex,
      required this.editAge,
      required this.applyChanges,
      required this.firstName,
      required this.lastName,
      required this.age,
      required this.sex});

  SettingsInitial copyWith({
    String? firstName,
    String? lastName,
    int? age,
    Sex? sex,
    bool? editFirstName,
    bool? editLastName,
    bool? editSex,
    bool? editAge,
    bool? applyChanges,
  }) {
    return SettingsInitial(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      editFirstName: editFirstName ?? this.editFirstName,
      editLastName: editLastName ?? this.editLastName,
      editSex: editSex ?? this.editSex,
      editAge: editAge ?? this.editAge,
      applyChanges: applyChanges ?? this.applyChanges,
    );
  }

  @override
  List<Object> get props => [
        firstName,
        lastName,
        age,
        sex,
        applyChanges,
        editFirstName,
        editLastName,
        editAge,
        editSex
      ];
}
