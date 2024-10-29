import '../../data/models/response/price_model.dart';

abstract class TradingState {}

class PriceLoading extends TradingState {}

class InstrumentsLoaded extends TradingState {
  final List<Price> prices;

  InstrumentsLoaded(this.prices);
}

class PriceUpdated extends TradingState {
  final List<Price> prices;

  PriceUpdated(this.prices);
}

class PriceError extends TradingState {
  final String message;

  PriceError(this.message);
}
