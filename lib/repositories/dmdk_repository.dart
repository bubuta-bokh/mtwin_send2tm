import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DmdkRepository {
  Dio dio = Dio();
  final logger = Logger(printer: PrettyPrinter());
  Future<Dio> makeBaseUrl() async {
    dio.options.baseUrl = 'http://localhost:15243/';
    return dio;
  }

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
}
