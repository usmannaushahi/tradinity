import 'package:tradinity/features/trading_instruments/data/repository_impl/trading_instruments_repo_impl.dart';

import '../../features/trading_instruments/domain/repository/trading_instruments_repo.dart';
import 'injection_container.dart';

Future<void> initDomainDI() async {
  // REPOSITORIES
  sl.registerLazySingleton<TradingInstrumentsRepo>(
    () => TradingInstrumentsRepoImpl(
      networkInfo: sl(),
      dataSource: sl(),
    ),
  );
}
