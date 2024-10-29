import 'package:dio/dio.dart';
import 'package:tradinity/core/network/network_constants.dart';
import 'package:tradinity/core/utils/custom_logger.dart';

import '../../../../core/error/custom_exceptions.dart';
import '../../../../core/network/network_client.dart';
import '../../../../core/utils/utils.dart';

abstract class TradingInstrumentDataSource {
  Future<dynamic> fetchInstruments();
}

class TradingInstrumentDataSourceImpl extends TradingInstrumentDataSource {
  final NetworkClient networkClient;
  final CustomLogger logger;
  TradingInstrumentDataSourceImpl(
      {required this.networkClient, required this.logger});

  @override
  Future fetchInstruments() async {
    final apiKey = kGetAPIKEY();
    var response = await networkClient.invoke(
      kInstrumentsAPI,
      RequestType.get,
      queryParameters: {"exchange": "oanda", "token": apiKey},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response;
    } else {
      logger.error(response.data);
      throw ServerException(
        dioError: DioException(
          error: response,
          type: DioExceptionType.unknown,
          requestOptions: response.requestOptions,
        ),
      );
    }
  }
}
