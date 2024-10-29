import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:tradinity/core/di/injection_container.dart';
import 'package:tradinity/core/error/custom_exceptions.dart';
import 'package:tradinity/core/network/network_client.dart';
import 'package:tradinity/core/utils/custom_logger.dart';
import 'package:tradinity/features/trading_instruments/data/data_source/trading_instruments_data_source.dart';

class MockNetworkClient extends Mock implements NetworkClient {}

void main() {
  late TradingInstrumentDataSourceImpl dataSource;
  late MockNetworkClient mockNetworkClient;
  late CustomLogger customLogger;

  setUp(() async {
    sl.reset();
    // Initialize DI
    await initDI();
    mockNetworkClient = MockNetworkClient();
    customLogger = CustomLogger();
    dataSource = TradingInstrumentDataSourceImpl(
        networkClient: mockNetworkClient, logger: customLogger);
  });
  tearDown(() {
    sl.reset(); // Reset after each test to avoid conflicts
  });
  group('TradingInstrumentDataSource', () {
    test('returns data when the response is successful', () async {
      // Arrange
      final responseData = {
        'data': [
          {
            'description': 'Apple Inc.',
            'displaySymbol': 'AAPL',
            'symbol': 'AAPL'
          },
          {
            'description': 'Google LLC',
            'displaySymbol': 'GOOGL',
            'symbol': 'GOOGL'
          },
        ]
      };
      when(mockNetworkClient.invoke(any, RequestType.get,
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
              statusCode: 200,
              data: responseData,
              requestOptions: RequestOptions()));

      // Act
      final result = await dataSource.fetchInstruments();

      // Assert
      expect(result, isA<Response>());
      expect(result.data['data'].length, 2);
    });

    test('throws ServerException when the response is not successful',
        () async {
      // Arrange
      when(mockNetworkClient.invoke(any, RequestType.get,
              queryParameters: anyNamed('queryParameters')))
          .thenThrow(ServerException(
              dioError: DioException(requestOptions: RequestOptions())));

      // Act & Assert
      expect(() async => await dataSource.fetchInstruments(),
          throwsA(isA<ServerException>()));
    });
  });
}
