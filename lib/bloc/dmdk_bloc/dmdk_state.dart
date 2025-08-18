part of 'dmdk_bloc.dart';

abstract class DmdkState extends Equatable {
  const DmdkState();

  @override
  List<Object> get props => [];
}

class DmdkInitialState extends DmdkState {}

class GotHealthRequestResult extends DmdkState {
  final bool healthRequestIsOk;

  const GotHealthRequestResult(this.healthRequestIsOk);
  @override
  List<Object> get props => [healthRequestIsOk];
}
