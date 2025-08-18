part of 'ticket_bloc.dart';

sealed class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object> get props => [];
}

class TicketInitialEvent extends TicketEvent {
  final String envi;

  const TicketInitialEvent({required this.envi});
  @override
  List<Object> get props => [envi];
}

class TicketSearchEvent extends TicketEvent {
  final String searchQuery;

  const TicketSearchEvent({required this.searchQuery});

  @override
  List<Object> get props => [searchQuery];
}
