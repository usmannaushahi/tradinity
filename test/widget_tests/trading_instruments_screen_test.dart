import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradinity/core/di/injection_container.dart';
import 'package:tradinity/features/trading_instruments/data/models/response/price_model.dart';
import 'package:tradinity/features/trading_instruments/presentation/cubit/trading_cubit.dart';
import 'package:tradinity/features/trading_instruments/presentation/cubit/trading_state.dart';
import 'package:tradinity/features/trading_instruments/presentation/screens/trading_instruments_screen.dart';
import 'package:tradinity/features/trading_instruments/presentation/screens/widgets/instrument_tile.dart';

void main() {
  group('TradingInstrumentsScreen', () {
    late TradingCubit tradingCubit;

    setUp(() async{
      sl.reset();
      // Initialize DI
      await initDI();
      tradingCubit = TradingCubit(); // Initialize your TradingCubit here
    });

    tearDown(() {
      sl.reset(); // Reset after each test to avoid conflicts
    });
    testWidgets('displays loading indicator when state is PriceLoading',
        (WidgetTester tester) async {
      // Arrange
      tradingCubit.emit(PriceLoading());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: tradingCubit,
            child: const TradingInstrumentsScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when state is PriceError',
        (WidgetTester tester) async {
      // Arrange
      tradingCubit.emit(PriceError('An error occurred'));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: tradingCubit,
            child: const TradingInstrumentsScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('An error occurred'), findsOneWidget);
    });

    testWidgets('displays list of instruments when state is InstrumentsLoaded',
        (WidgetTester tester) async {
      // Arrange
      final price1 = Price(symbol: 'AAPL', price: 150.0, name: 'Apple Inc.')
        ..previousPrice = 145.0; // Set previous price for comparison
      final price2 =
          Price(symbol: 'GOOGL', price: 2800.0, name: 'Alphabet Inc.')
            ..previousPrice = 2900.0; // Set previous price for comparison

      final prices = [price1, price2];
      tradingCubit.emit(InstrumentsLoaded(prices));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: tradingCubit,
            child: const TradingInstrumentsScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(InstrumentTile), findsNWidgets(prices.length));
      expect(find.text('AAPL'), findsOneWidget);
      expect(find.text('Alphabet Inc.'), findsOneWidget);
    });

    testWidgets('displays unexpected state message when state is unknown',
        (WidgetTester tester) async {
      // Arrange
      // tradingCubit.emit(UnknownState());

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider.value(
            value: tradingCubit,
            child: const TradingInstrumentsScreen(),
          ),
        ),
      );

      // Assert
      expect(find.text('Unexpected state.'), findsOneWidget);
    });
  });
}
