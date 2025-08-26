import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:mtwin_send2tm/entities/snackbar_global.dart';
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

      try {
        ticketDto = await ticketRepository.searchSoldTickets(
          searchQuery: event.searchQuery,
          qty: event.qty ?? 5,
        );
        if (ticketDto == null) {
          SnackbarGlobal.show(
            'Не удалось получить данные с сервера.',
            20,
            'warn',
          );
          emit(SearchTicketError('Не удалось получить данные с сервера.'));
        } else {
          if (ticketDto!.isEmpty) {
            SnackbarGlobal.show(
              'По вашему запросу ничего не найдено.',
              10,
              'warn',
            );
            emit(SearchTicketError('По вашему запросу ничего не найдено.'));
            return;
          } else {
            SnackbarGlobal.show(
              'Данные с сервера успешно получены!',
              20,
              'success',
            );
          }
          emit(SearchTicketLoaded(ticketDto!));
        }
      } catch (e) {
        //myLogger.e(e.toString());
        SnackbarGlobal.show(e.toString(), 10, 'error');
        emit(SearchTicketError(e.toString()));
      }
    });
  }
}
