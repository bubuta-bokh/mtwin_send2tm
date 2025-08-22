import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
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
      //logger.i("Inside BLOC, before health request is made");
      //var isSuccessfull = await dmdkRepository.makeHealthRequest();
    });
  }
}
