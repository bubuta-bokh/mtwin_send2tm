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
