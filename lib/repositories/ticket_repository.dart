import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class TicketRepository {
  Dio dio = Dio();
  final logger = Logger(printer: PrettyPrinter());

  Future<bool> prepareDio(String envi) async {
    try {
      if (envi.toUpperCase() == 'DEV') {
        dio.options.baseUrl =
            'https://dev-ws.mtwin.ru/TicketService/api/TicketV2/';
      } else if (envi.toUpperCase() == 'PROD') {
        dio.options.baseUrl = 'https://ws.mtwin.ru/TicketService/api/TicketV2/';
      } else {
        dio.options.baseUrl = 'http://localhost:64400/api/TicketV2/';
      }

      //logger.i('Dio base url has changed!');
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
