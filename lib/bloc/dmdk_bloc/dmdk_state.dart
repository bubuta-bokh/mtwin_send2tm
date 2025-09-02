part of 'dmdk_bloc.dart';

abstract class DmdkState extends Equatable {
  const DmdkState();

  @override
  List<Object> get props => [];
}

class DmdkInitialState extends DmdkState {}

class DmdkFileSentWithSuccessState extends DmdkState {
  final TicketDto ticketDto;
  const DmdkFileSentWithSuccessState({required this.ticketDto});
  @override
  List<Object> get props => [ticketDto];
}

class GotHealthRequestResult extends DmdkState {
  final bool healthRequestIsOk;

  const GotHealthRequestResult(this.healthRequestIsOk);
  @override
  List<Object> get props => [healthRequestIsOk];
}
