import 'package:dartz/dartz.dart';
import 'package:tradinity/features/trading_instruments/data/data_source/trading_instruments_data_source.dart';
import '../../../../core/error/custom_exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repository/trading_instruments_repo.dart';
import '../models/response/instrument_model.dart';

class TradingInstrumentsRepoImpl extends TradingInstrumentsRepo {
  final NetworkInfo networkInfo;
  final TradingInstrumentDataSource dataSource;
  TradingInstrumentsRepoImpl(
      {required this.networkInfo, required this.dataSource});

  @override
  Future<Either<Exception, List<Instrument>>> fetchInstruments() async {
    if (!await networkInfo.isConnected) {

      return Left(NoInternetException(message: "No internet connection"));
    }
    try {
      final response = await dataSource.fetchInstruments();
      final data = response.data as List;
      final instruments = Instrument.fromJsonList(data);
      return Right(instruments);
    } on ServerException catch (exception) {
      return Left(exception);
    }
  }
}
