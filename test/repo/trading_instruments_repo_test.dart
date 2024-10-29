import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:tradinity/core/di/injection_container.dart';
import 'package:tradinity/core/error/custom_exceptions.dart';
import 'package:tradinity/core/network/network_info.dart';
import 'package:tradinity/features/trading_instruments/data/data_source/trading_instruments_data_source.dart';
import 'package:tradinity/features/trading_instruments/data/models/response/instrument_model.dart';
import 'package:tradinity/features/trading_instruments/data/repository_impl/trading_instruments_repo_impl.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockTradingInstrumentDataSource extends Mock
    implements TradingInstrumentDataSource {}

void main() {
  late TradingInstrumentsRepoImpl tradingRepo;
  late MockNetworkInfo mockNetworkInfo;
  late MockTradingInstrumentDataSource mockDataSource;

  setUp(() async{
    sl.reset();
    // Initialize DI
    await initDI();
    mockNetworkInfo = MockNetworkInfo();
    mockDataSource = MockTradingInstrumentDataSource();
    tradingRepo = TradingInstrumentsRepoImpl(
      networkInfo: mockNetworkInfo,
      dataSource: mockDataSource,
    );
  });

  tearDown(() {
    sl.reset(); // Reset after each test to avoid conflicts
  });

  group('TradingInstrumentsRepo', () {
    test('returns a list of instruments when the network is connected',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDataSource.fetchInstruments()).thenAnswer((_) async => [
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
          ]);

      // Act
      final result = await tradingRepo.fetchInstruments();

      // Assert
      expect(result, isA<Right<Exception, List<Instrument>>>());
      final instruments = result.getOrElse(() => []);
      expect(instruments.length, 2);
      expect(instruments[0].description, 'Apple Inc.');
      expect(instruments[1].description, 'Google LLC');
    });

    test('returns NoInternetException when there is no network', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await tradingRepo.fetchInstruments();

      // Assert
      expect(result, isA<Left<Exception, List<Instrument>>>());
      expect(result.fold((l) => l, (r) => null), isA<NoInternetException>());
    });

    test('returns ServerException when data source fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockDataSource.fetchInstruments()).thenThrow(ServerException(
          dioError: DioException(requestOptions: RequestOptions())));

      // Act
      final result = await tradingRepo.fetchInstruments();

      // Assert
      expect(result, isA<Left<Exception, List<Instrument>>>());
      expect(result.fold((l) => l, (r) => null), isA<ServerException>());
    });
  });
}
