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
  final int? qty;

  const TicketSearchEvent({required this.searchQuery, required this.qty});

  @override
  List<Object> get props => [searchQuery, qty ?? 5];
}
