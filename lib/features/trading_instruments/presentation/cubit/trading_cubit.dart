import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:tradinity/core/utils/custom_logger.dart';
import 'package:tradinity/features/trading_instruments/domain/repository/trading_instruments_repo.dart';
import 'package:tradinity/features/trading_instruments/presentation/cubit/trading_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/network_constants.dart';
import '../../../../core/utils/utils.dart';
import '../../data/models/response/instrument_model.dart';
import '../../data/models/response/price_model.dart';
import 'package:dartz/dartz.dart';

class TradingCubit extends Cubit<TradingState> {
  TradingInstrumentsRepo priceRepository = sl();
  WebSocketChannel? _channel;
  List<Price> _symbolPrices = [];
  String? apiKey;
  final CustomLogger logger = sl<CustomLogger>();
  TradingCubit() : super(PriceLoading());

  Future<void> fetchInstruments() async {
    try {
      emit(PriceLoading());
      Either<Exception, List<Instrument>> response =
          await priceRepository.fetchInstruments();

      response.fold((left) {
        logger.error("Error fetching instruments: $left");
        emit(PriceError("Error fetching instruments: $left"));
      }, (right) {
        // Initialize prices to null
        _symbolPrices = right.map((instrument) {
          return Price(
              symbol: instrument.symbol,
              price: null,
              name: instrument.description);
        }).toList();

        emit(InstrumentsLoaded(_symbolPrices));

        // Subscribe to WebSocket for real-time updates
        if ((apiKey ?? "").isEmpty) {
          apiKey = kGetAPIKEY();
        }
        _subscribeToPrices(apiKey);
      });
    } catch (e) {
      logger.error("Error fetching instruments: $e");
      emit(PriceError("Error fetching instruments: $e"));
    }
  }

  void _subscribeToPrices(String? apiKey) {
    if (apiKey == null) {
      logger.error('Unable to subscribe. API KEY is NULL');
      return;
    }

    // Initialize and subscribe
    _channel = WebSocketChannel.connect(
      Uri.parse('$kSocketUrl?token=$apiKey'),
    );

    // Subscribe once by sending multiple symbols in a batch, if supported
    final subscriptions = _symbolPrices
        .map((symbol) => {
              'type': 'subscribe',
              'symbol': symbol.symbol,
            })
        .toList();
    subscriptions.forEach((message) => _channel!.sink.add(jsonEncode(message)));

    _channel!.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      if (decodedMessage['data'] != null) {
        final prices = _parsePriceData(decodedMessage['data']);
        prices.forEach((price) => updateSymbolPrice(price.symbol, price.price));
        emit(PriceUpdated(_symbolPrices));
      }
    }, onError: (error) {
      emit(PriceError("WebSocket error: $error"));
    });
  }

  List<Price> _parsePriceData(dynamic data) {
    return data.map<Price>((item) => Price.fromJson(item)).toList();
  }

  void updateSymbolPrice(String symbol, double? newPrice) {
    final index = _symbolPrices.indexWhere((price) => price.symbol == symbol);
    if (index != -1) {
      _symbolPrices[index].previousPrice =
          _symbolPrices[index].price ?? 0; // Save previous price for comparison
      _symbolPrices[index].price = newPrice; // Update new price
    }
  }

  @override
  Future<void> close() {
    _channel?.sink.close();
    return super.close();
  }
}
