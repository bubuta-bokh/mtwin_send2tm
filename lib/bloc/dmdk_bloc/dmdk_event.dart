part of 'dmdk_bloc.dart';

sealed class DmdkEvent extends Equatable {
  const DmdkEvent();

  @override
  List<Object> get props => [];
}

class DmdkInitialEvent extends DmdkEvent {}

class DmdkHealthRequestMade extends DmdkEvent {}

class ProcessTicketSendEvent extends DmdkEvent {
  final TicketDto ticketForTM;

  const ProcessTicketSendEvent(this.ticketForTM);

  @override
  List<Object> get props => [ticketForTM];
}
