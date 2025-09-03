import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:mtwin_send2tm/entities/my_logger.dart';
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
      myLogger.i('[From dmdk_bloc] Line 31. Before xml is born.');
      //emit(DmdkFileSentWithSuccessState(ticketDto: event.ticketForTM));
      //return;

      try {
        var bytes = await dmdkRepository.createChequeXmlFile(
          ticket: event.ticketForTM,
        );
        myLogger.i(
          '[From dmdk_bloc] Line 39. ✅ Файл успешно создан в памяти. Размер: ${bytes.length} байт.',
        );
        SnackbarGlobal.show(
          '✅ Файл успешно создан в памяти. Размер: ${bytes.length} байт.',
          7,
          'success',
        );

        try {
          var rslt = await dmdkRepository.sendChequeXmlFile(xmlBytes: bytes);
          if (!rslt.contains('error')) {
            myLogger.i(
              '[From dmdk_bloc] Line 50. ✅ Файл успешно отправлен в ТМ: $rslt,',
            );
            SnackbarGlobal.show(
              '✅ Файл успешно отправлен в ТМ: $rslt,',
              20,
              'success',
            );

            emit(DmdkFileSentWithSuccessState(ticketDto: event.ticketForTM));
          } else {
            myLogger.e(
              '[From dmdk_bloc] Line 61. ❌ Файл НЕ был отправлен в ТМ. Ошибка: $rslt',
            );
            SnackbarGlobal.show(rslt, 20, 'error');
          }
        } catch (e, s) {
          myLogger.e(
            '[From dmdk_bloc] Line 67. ❌ Файл НЕ был отправлен в ТМ. Ошибка: $e, stack trace: $s',
          );
          SnackbarGlobal.show(
            'Не удалось отправить XML файл в ТМ. Ошибка: $e, stack trace: $s',
            20,
            'error',
          );
        }
      } catch (e, s) {
        myLogger.e(
          '[From dmdk_bloc] Line 77. ❌ Не удалось создать XML-файл, ошибка: $e, stack trace: $s',
        );
        SnackbarGlobal.show(
          'Не удалось создать XML-файл, ошибка: $e, stack trace: $s',
          20,
          'error',
        );
      }
    });
  }
}
