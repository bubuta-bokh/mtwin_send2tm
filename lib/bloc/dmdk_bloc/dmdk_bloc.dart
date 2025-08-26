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
      try {
        var file = await dmdkRepository.createChequeXmlFile(
          ticket: event.ticketForTM,
        );
        if (file == null) {
          SnackbarGlobal.show('Не удалось создать XML файл.', 10, 'warn');
          return;
        } else {
          try {
            var rslt = await dmdkRepository.sendChequeXmlFile(
              file: file,
              fileName: '${event.ticketForTM.ticketObjectNumber}.xml',
            );
            if (rslt.contains('error')) {
              SnackbarGlobal.show(rslt, 20, 'error');
            } else {
              SnackbarGlobal.show(rslt, 20, 'success');
            }
          } catch (e) {
            SnackbarGlobal.show(
              'Не удалось отправить XML файл. $e',
              20,
              'error',
            );
          }
        }
      } catch (e) {
        //myLogger.e(e.toString());
        SnackbarGlobal.show(e.toString(), 20, 'error');
        //var isSuccessfull = await dmdkRepository.makeHealthRequest();
      }
    });
  }
}
