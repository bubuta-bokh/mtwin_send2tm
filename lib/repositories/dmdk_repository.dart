import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:mtwin_send2tm/entities/ticket_dto.dart';
import 'package:xml/xml.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:http_parser/http_parser.dart';

class DmdkRepository {
  Dio dio = Dio();
  final logger = Logger(printer: PrettyPrinter());
  Future<Dio> makeBaseUrl() async {
    dio.options.baseUrl = 'http://localhost:15243/';
    return dio;
  }

  String fn = '';
  String address = '';
  final String fn_iz = '7380440800954751';
  final String fn_zr = '7380440800954745';
  final String fn_kl = '7380440800954742';
  final String fn_tp = '7380440801582121';
  final String fn_bk = '7380440700574577';
  final String fn_gr = '7380440902315518';
  final String inn = '7810243050';
  final String kpp = '784201001';
  final String address_iz = '197198, г.Санкт-Петербург, ул.Ижорская, д.13/39';
  final String address_zr = '198328, СПб,ул. Маршала Захарова, д.21';
  final String address_kl = '193312, г.Санкт-Петербург, ул. Коллонтай, д.30';
  final String address_tp = '196135, Санкт-Петербург, Типанова ул, д. 5';
  final String address_bk = '192238, СПб, ул. Белы Куна, д.8, лит.А';
  final String address_gr =
      '195220, г. Санкт-Петербург, Гражданский пр., д. 33, литера А, пом. 15Н';
  final String name = 'ООО "Ломбард  "Престиж"';
  final String filePath = 'C:\\utl\\xml';

  Future<String> makeHealthRequest() async {
    //logger.i('We are inside of makeHealthRequest');

    try {
      var response = await dio.post(
        'health',
        data: {
          'certificateSerial': "0187146c00a1b0b89b4a3bbf4297843c0d",
          'stunnelPort': '1500',
        },
      );
      final int? statusCode = response.statusCode;
      //logger.i('A status code=$statusCode');
      return response.data;
    } on DioException catch (e) {
      final String msg = e.response?.data['exceptionMessage'];
      if (e.response?.statusCode == 404) {
        logger.e(msg);
      } else {
        logger.e(msg);
      }
      return msg;
    }
  }

  Future<Uint8List> createChequeXmlFile({required TicketDto ticket}) async {
    try {
      final builder = XmlBuilder();
      if (ticket.ticketNumber.startsWith('ИЖ')) {
        fn = fn_iz;
        address = address_iz;
      } else if (ticket.ticketNumber.startsWith('ЗР')) {
        fn = fn_zr;
        address = address_zr;
      } else if (ticket.ticketNumber.startsWith('КЛ')) {
        fn = fn_kl;
        address = address_kl;
      } else if (ticket.ticketNumber.startsWith('ТП')) {
        fn = fn_tp;
        address = address_tp;
      } else if (ticket.ticketNumber.startsWith('БК')) {
        fn = fn_bk;
        address = address_bk;
      } else if (ticket.ticketNumber.startsWith('ГР')) {
        fn = fn_gr;
        address = address_gr;
      } else {
        fn = fn_iz;
        address = address_iz;
      }
      builder.processing('xml', 'version="1.0" encoding="UTF-8"');
      builder.element(
        'Cheque',
        nest: () {
          builder.attribute('inn', inn);
          builder.attribute('kpp', kpp);
          builder.attribute('address', address);
          builder.attribute('name', name);
          builder.attribute('kassa', fn);
          builder.attribute('shift', ticket.shiftNumber);
          builder.attribute('number', ticket.chequeNumber);
          builder.attribute('datetime', ticket.soldDate);

          builder.element(
            'Bottle',
            nest: () {
              builder.attribute('price', ticket.sellPrice);
              builder.attribute('barcode', ticket.uin);
            },
          );
        },
      );

      final document = builder.buildDocument();
      final xmlString = document.toXmlString(pretty: true, indent: '  ');
      final xmlBytes = utf8.encode(xmlString);

      //final file = File('$filePath\\${ticket.ticketObjectNumber}.xml');

      //await file.create(recursive: true);
      //await file.writeAsString(xmlString);
      logger.i('XML file created in memory for ticket: ${ticket.uin}');
      return xmlBytes;
    } on DioException catch (e) {
      logger.e('Error during XML file creation: $e');
      //final String msg = e.response?.data['exceptionMessage'];
      //final String msg = e.message ?? e.response?.data['exceptionMessage'];
      rethrow;
    }
  }

  Future<String> sendChequeXmlFile({required Uint8List xmlBytes}) async {
    try {
      // final formData = FormData.fromMap({
      //   "xml_file": await MultipartFile.fromFile(
      //     file.path,
      //     filename: fileName, // optional, can use basename(file.path)
      //   ),
      // });

      final formData = FormData.fromMap({
        "xml_file": MultipartFile.fromBytes(
          xmlBytes,
          filename: 'cheque.xml',
          contentType: MediaType('application', 'xml'),
        ),
      });

      final response = await dio.post(
        "xml",
        data: formData,
        options: Options(
          headers: {
            "Content-Type":
                "multipart/form-data", // Dio sets this automatically
          },
        ),
      );

      logger.i("Status: ${response.statusCode}");
      logger.i("Response: ${response.data}");
      return 'Status: ${response.statusCode} Response: ${response.data}';
    } on DioException catch (e) {
      logger.e('Error during XML file sending to TM: $e');
      rethrow;
      // final String msg = e.message ?? e.response?.data['exceptionMessage'];
      // if (e.response?.statusCode == 404) {
      //   logger.e(msg);
      // } else {
      //   logger.e(msg);
      // }
      // return msg;
    }
  }
}
