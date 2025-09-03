import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:mtwin_send2tm/entities/my_logger.dart';
import 'package:mtwin_send2tm/entities/ticket_dto.dart';

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

  String generatePassphrase(DateTime currentDate) {
    final passPhraseRaw =
        'Мария${currentDate.day}Борисовна${currentDate.month}Филимохина${currentDate.year}';

    // MD5 hash
    final bytes = utf8.encode(passPhraseRaw);
    final digest = md5.convert(bytes);

    // Convert to lowercase hex string, two chars per byte
    final passPhrase = digest.bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    return passPhrase;
  }

  Future<List<TicketDto>> searchSoldTickets({
    String? searchQuery,
    int qty = 5,
  }) async {
    try {
      DateTime now = DateTime.now();
      String passPhrase = generatePassphrase(now);
      searchQuery ??= '';
      var response = await dio.get(
        'SearchSoldTicketObjectsTm',
        queryParameters: {
          'searchQuery': searchQuery,
          'token': passPhrase,
          'qty': qty,
          'doLog': true,
        },
      );
      final int? statusCode = response.statusCode;
      if (statusCode! < 200 || statusCode > 400) {
        myLogger.e(
          '[From ticket_repository] Line 66. Сервер бэк-энда вернул статус-код ошибки: $statusCode.',
        );
        throw Exception(
          "Сервер бэк-энда вернул статус-код ошибки: $statusCode.",
        );
      } else {
        var s = response.data as List;
        List<TicketDto> rslt = [];
        for (var element in s) {
          rslt.add(TicketDto.fromJson(element));
        }
        return rslt;
      }
    } on DioException catch (e) {
      return throw Exception(e);
    } on Exception catch (e) {
      myLogger.e(
        '[From ticket_repository] Line 83. Ошибка во время процедуры поиска проданных вещей на бэк-энде: $e',
      );

      return throw Exception(e);
    }
  }

  Future<bool> markTicketAsSentToTM(TicketDto ticketDto) async {
    try {
      DateTime now = DateTime.now();
      String passPhrase = generatePassphrase(now);
      myLogger.i(
        '[From ticket_repository] Line 95. Marking ticket ${ticketDto.uin} as sent to TM. Pasphrase = $passPhrase',
      );
      var response = await dio.post(
        'MarkTicketAsSentToTM',
        data: {
          'ticketObjectId': ticketDto.ticketObjectId,
          'token': passPhrase,
          'doLog': true,
        },
      );
      final int? statusCode = response.statusCode;
      if (statusCode! < 200 || statusCode > 400) {
        myLogger.e(
          '[From ticket_repository] Line 106. Сервер бэк-энда вернул статус-код ошибки: $statusCode.',
        );
        throw Exception(
          "Сервер бэк-энда вернул статус-код ошибки: $statusCode.",
        );
      } else {
        return response.data as bool;
      }
    } on DioException catch (e) {
      return throw Exception(e);
    } on Exception catch (e) {
      myLogger.e(
        '[From ticket_repository] Line 118. Ошибка во время процедуры сохранения статуса вещи как отправленной в ТМ на бэк-энде: $e',
      );
      return throw Exception(e);
    }
  }
}
