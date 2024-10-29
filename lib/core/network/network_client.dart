import 'package:dio/dio.dart';
import 'package:tradinity/core/utils/custom_logger.dart';

import '../error/custom_exceptions.dart';
import 'network_constants.dart';

class NetworkClient {
  final Dio dio;
  final CustomLogger logger;

  NetworkClient({
    required this.dio,
    required this.logger,
  });

  Future<Response> invoke(String? url, RequestType requestType,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      dynamic requestBody}) async {
    Response? response;

    dio.options.baseUrl = kBaseUrl;

    logger.info(
        'Endpoint: $kBaseUrl$url\n\nRequestType: $requestType\n\nQueryParameters: $queryParameters\n\nRequestBody: $requestBody');

    try {
      switch (requestType) {
        case RequestType.get:
          response = await dio.get(url ?? '',
              queryParameters: queryParameters,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          logger.info('Response: $response\n\n');
          break;
        case RequestType.post:
          response = await dio.post(url ?? '',
              queryParameters: queryParameters,
              data: requestBody,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          logger.info('Response: $response\n\n');
          break;
        case RequestType.put:
          response = await dio.put(url ?? '',
              queryParameters: queryParameters,
              data: requestBody,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          logger.info('Response: $response\n\n');
          break;
        case RequestType.delete:
          response = await dio.delete(url ?? '',
              queryParameters: queryParameters,
              data: requestBody,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          logger.info('Response: $response\n\n');
          break;
        case RequestType.patch:
          response = await dio.patch(url ?? '',
              queryParameters: queryParameters,
              data: requestBody,
              options:
                  Options(responseType: ResponseType.json, headers: headers));
          logger.info('Response: $response\n\n');
          break;
      }
      return response;
    } on DioException catch (dioError) {
      logger.error(
          "Logs: Request Parameter or Request Body is ${dioError.requestOptions?.queryParameters ?? dioError.requestOptions?.data}");

      throw ServerException(dioError: dioError);
    }
  }
}

// Types used by invoke API.
enum RequestType { get, post, put, delete, patch }
