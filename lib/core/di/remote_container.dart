import '../../features/trading_instruments/data/data_source/trading_instruments_data_source.dart';
import 'injection_container.dart';

Future<void> initRemoteDI() async {
  // DATA SOURCES
  sl.registerLazySingleton<TradingInstrumentDataSource>(() =>
      TradingInstrumentDataSourceImpl(networkClient: sl(), logger: sl()));
}
