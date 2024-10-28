import 'package:equatable/equatable.dart';

sealed class InfoCollectorState extends Equatable {}

class InfoCollectorInitialState extends InfoCollectorState {
  @override
  List<Object?> get props => [];
}

class InfoCollectorWrongFirstNameState extends InfoCollectorState {
  @override
  List<Object?> get props => [];
}

class InfoCollectorWrongLastNameState extends InfoCollectorState {
  @override
  List<Object?> get props => [];
}

class InfoCollectorNoInternetState extends InfoCollectorState {
  @override
  List<Object?> get props => [];
}
