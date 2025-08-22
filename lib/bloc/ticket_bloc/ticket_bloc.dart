import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:mtwin_send2tm/entities/ticket_dto.dart';
import 'package:mtwin_send2tm/repositories/ticket_repository.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;
  List<TicketDto>? ticketDto;

  final logger = Logger(printer: PrettyPrinter());

  TicketBloc({required this.ticketRepository}) : super(TicketInitial()) {
    on<TicketInitialEvent>((event, emit) async {
      //logger.i('Inside ticket bloc line 21');
      var wasSuccessfull = await ticketRepository.prepareDio(event.envi);
    });

    on<TicketSearchEvent>((event, emit) async {
      logger.i('Inside ticket bloc line 22');
      emit(SearchTicketLoading());

      ticketDto = await ticketRepository.searchSoldTickets(
        searchQuery: event.searchQuery,
        qty: event.qty ?? 5,
      );
      if (ticketDto == null) {
        emit(SearchTicketError('Не удалось получить данные с сервера.'));
      } else {
        emit(SearchTicketLoaded(ticketDto!));
      }
    });
  }
}
