import 'dart:io';
import 'package:mtwin_send2tm/entities/ticket_dto.dart';
import 'package:xml/xml.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DmdkRepository {
  Dio dio = Dio();
  final logger = Logger(printer: PrettyPrinter());
  Future<Dio> makeBaseUrl() async {
    dio.options.baseUrl = 'http://localhost:15243/';
    return dio;
  }

  final String fn = '7380440800954751';
  final String inn = '7810243050';
  final String kpp = '784201001';
  final String address = '197198, г.Санкт-Петербург, ул.Ижорская, д.13/39';
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

  Future<File?> createChequeXmlFile({required TicketDto ticket}) async {
    try {
      final builder = XmlBuilder();

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

      final file = File('$filePath\\${ticket.ticketObjectNumber}.xml');

      await file.create(recursive: true);
      await file.writeAsString(xmlString);
      return file;
    } on DioException catch (e) {
      // final String msg = e.response?.data['exceptionMessage'];
      // if (e.response?.statusCode == 404) {
      //   logger.e(msg);
      // } else {
      //   logger.e(msg);
      // }
      // return msg;
    }

    // try {
    //   final formData = FormData.fromMap({
    //     "xml_file": await MultipartFile.fromFile(
    //       file.path,
    //       filename: "cheque.xml", // optional, can use basename(file.path)
    //     ),
    //   });

    //   final response = await dio.post(
    //     "xml",
    //     data: formData,
    //     options: Options(
    //       headers: {
    //         "Content-Type":
    //             "multipart/form-data", // Dio sets this automatically
    //       },
    //     ),
    //   );

    //   logger.i("Status: ${response.statusCode}");
    //   logger.i("Response: ${response.data}");
    // } catch (e) {
    //   logger.e("Upload failed: $e");
    // }

    logger.i('XML file saved at $filePath');
  }

  Future<String> sendChequeXmlFile({
    required File file,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        "xml_file": await MultipartFile.fromFile(
          file.path,
          filename: fileName, // optional, can use basename(file.path)
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
      final String msg = e.message ?? e.response?.data['exceptionMessage'];
      if (e.response?.statusCode == 404) {
        logger.e(msg);
      } else {
        logger.e(msg);
      }
      return msg;
    }
  }
}
