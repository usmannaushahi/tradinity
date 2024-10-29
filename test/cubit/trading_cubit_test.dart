import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:tradinity/features/trading_instruments/data/models/response/instrument_model.dart';
import 'package:tradinity/features/trading_instruments/domain/repository/trading_instruments_repo.dart';
import 'package:tradinity/features/trading_instruments/presentation/cubit/trading_cubit.dart';
import 'package:tradinity/features/trading_instruments/presentation/cubit/trading_state.dart';

class MockTradingInstrumentsRepo extends Mock
    implements TradingInstrumentsRepo {}

void main() {
  late TradingCubit tradingCubit;
  late MockTradingInstrumentsRepo mockRepo;

  setUp(() {
    mockRepo = MockTradingInstrumentsRepo();
    tradingCubit = TradingCubit();
  });

  group('TradingCubit', () {
    test('initial state is PriceLoading', () {
      expect(tradingCubit.state, PriceLoading());
    });

    blocTest<TradingCubit, TradingState>(
      'emits [PriceLoading, InstrumentsLoaded] when fetchInstruments is successful',
      build: () {
        when(mockRepo.fetchInstruments()).thenAnswer((_) async => Right([
              Instrument(
                  description: 'Apple Inc.',
                  displaySymbol: 'AAPL',
                  symbol: 'AAPL'),
              Instrument(
                  description: 'Google LLC',
                  displaySymbol: 'GOOGL',
                  symbol: 'GOOGL'),
            ]));
        return tradingCubit;
      },
      act: (cubit) => cubit.fetchInstruments(),
      expect: () => [
        PriceLoading(),
        isA<InstrumentsLoaded>(),
      ],
    );

    blocTest<TradingCubit, TradingState>(
      'emits [PriceLoading, PriceError] when fetchInstruments fails',
      build: () {
        when(mockRepo.fetchInstruments())
            .thenAnswer((_) async => Left(Exception('Error fetching')));
        return tradingCubit;
      },
      act: (cubit) => cubit.fetchInstruments(),
      expect: () => [
        PriceLoading(),
        isA<PriceError>(),
      ],
    );

    test('updates the symbol price correctly', () {
      // Arrange
      final instrument = Instrument(
          description: 'Apple Inc.', displaySymbol: 'AAPL', symbol: 'AAPL');
      tradingCubit.fetchInstruments(); // Fetch instruments to initialize prices
      tradingCubit.updateSymbolPrice(
          instrument.symbol, 150.0); // Simulate price update

      // Act
      tradingCubit.updateSymbolPrice(
          instrument.symbol, 155.0); // Update to a new price

      // Assert
      expect(tradingCubit.state,
          isA<PriceUpdated>()); // Check if the state has updated
      final updatedState = tradingCubit.state as PriceUpdated;

      // Verify that the price was updated
      final price =
          updatedState.prices.firstWhere((p) => p.symbol == instrument.symbol);
      expect(price.price, 155.0); // Check new price
      expect(price.previousPrice, 150.0); // Check previous price
    });
  });
}
