import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:mtwin_send2tm/entities/snackbar_global.dart';
import 'package:mtwin_send2tm/entities/ticket_dto.dart';
import 'package:mtwin_send2tm/repositories/dmdk_repository.dart';

part 'dmdk_event.dart';
part 'dmdk_state.dart';

class DmdkBloc extends Bloc<DmdkEvent, DmdkState> {
  final DmdkRepository dmdkRepository;
  final logger = Logger(printer: PrettyPrinter());

  DmdkBloc({required this.dmdkRepository}) : super(DmdkInitialState()) {
    on<DmdkInitialEvent>((event, emit) {
      //logger.i("Before base url was made");
      dmdkRepository.makeBaseUrl();
      //logger.i("Base url was made");
    });

    on<DmdkHealthRequestMade>((event, emit) async {
      //logger.i("Inside BLOC, before health request is made");
      //var isSuccessfull = await dmdkRepository.makeHealthRequest();
    });

    on<ProcessTicketSendEvent>((event, emit) async {
      logger.i("Inside BLOC, before xml is born");
      //emit(DmdkFileSentWithSuccessState(ticketDto: event.ticketForTM));
      //return;
      emit(DmdkFileSentWithSuccessState(ticketDto: event.ticketForTM));
      try {
        var bytes = await dmdkRepository.createChequeXmlFile(
          ticket: event.ticketForTM,
        );
        SnackbarGlobal.show(
          '✅ Файл успешно создан в памяти. Размер: ${bytes.length} байт.',
          7,
          'success',
        );

        try {
          var rslt = await dmdkRepository.sendChequeXmlFile(xmlBytes: bytes);
          if (!rslt.contains('error')) {
            SnackbarGlobal.show(
              '✅ Файл успешно отправлен в ТМ: $rslt,',
              20,
              'success',
            );

            emit(DmdkFileSentWithSuccessState(ticketDto: event.ticketForTM));
          } else {
            SnackbarGlobal.show(rslt, 20, 'error');
          }
        } catch (e, s) {
          SnackbarGlobal.show(
            'Не удалось отправить XML файл в ТМ. Ошибка: $e, stack trace: $s',
            20,
            'error',
          );
        }
      } catch (e, s) {
        //myLogger.e(e.toString());
        SnackbarGlobal.show(
          'Не удалось создать XML-файл, ошибка: $e, stack trace: $s',
          20,
          'error',
        );
        //var isSuccessfull = await dmdkRepository.makeHealthRequest();
      }
    });
  }
}
