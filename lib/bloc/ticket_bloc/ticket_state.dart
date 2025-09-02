part of 'ticket_bloc.dart';

sealed class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

final class TicketInitial extends TicketState {}

final class SearchTicketLoading extends TicketState {}

final class DoneWithThisTOState extends TicketState {}

final class SearchTicketError extends TicketState {
  final String message;

  const SearchTicketError(this.message);

  @override
  List<Object> get props => [message];
}

final class SearchTicketLoaded extends TicketState {
  final List<TicketDto> ticketsToSend;

  const SearchTicketLoaded(this.ticketsToSend);
  @override
  List<Object> get props => [ticketsToSend];
}
