import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:mtwin_send2tm/bloc/dmdk_bloc/dmdk_bloc.dart';
import 'package:mtwin_send2tm/entities/snackbar_global.dart';
import 'package:mtwin_send2tm/entities/ticket_dto.dart';
import 'package:mtwin_send2tm/repositories/ticket_repository.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;
  List<TicketDto>? ticketDto;
  final DmdkBloc dmdkBloc;
  StreamSubscription? _dmdkSubscription;

  final logger = Logger(printer: PrettyPrinter());

  TicketBloc({required this.ticketRepository, required this.dmdkBloc})
    : super(TicketInitial()) {
    _dmdkSubscription = dmdkBloc.stream.listen((dmdkState) {
      if (dmdkState is DmdkFileSentWithSuccessState) {
        //add(TicketMakeTOSentEvent(ticketDto: ticketDto!.first));
        //logger.i('DMDK file was sent successfully!');
        //var rslt = ticketRepository.markTicketAsSentToTM(dmdkState.ticketDto);
        // SnackbarGlobal.show('TicketBloc L30', 10, 'warn');

        add(TicketMarkTOAsSentToTMEvent(ticketDto: dmdkState.ticketDto));
      }
    });

    on<TicketInitialEvent>((event, emit) async {
      //logger.i('Inside ticket bloc line 21');
      var wasSuccessfull = await ticketRepository.prepareDio(event.envi);
    });

    on<TicketMarkTOAsSentToTMEvent>((event, emit) async {
      emit(TicketStartTransferState());
      try {
        var succeded = await ticketRepository.markTicketAsSentToTM(
          event.ticketDto,
        );
        if (succeded) {
          SnackbarGlobal.show(
            'Вещь успешно отмечена как отправленная на ТМ.',
            20,
            'success',
          );

          ticketDto!.removeWhere(
            (element) =>
                element.ticketObjectId == event.ticketDto.ticketObjectId,
          );

          emit(SearchTicketLoaded(ticketDto!));
        } else {
          SnackbarGlobal.show(
            'Вещь НЕ была отмечена как отправленная на ТМ.',
            20,
            'warn',
          );
        }
      } catch (e) {
        SnackbarGlobal.show(
          'Ошибка во время процедуры сохранения статуса вещи как отправленной в ТМ на бэк-энде: $e',
          20,
          'error',
        );
      }
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
              'Данные о вещах для отправки в ТМ с бэк-энда успешно получены!',
              7,
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

    @override
    Future<void> close() {
      _dmdkSubscription!.cancel();
      return super.close();
    }
  }
}
