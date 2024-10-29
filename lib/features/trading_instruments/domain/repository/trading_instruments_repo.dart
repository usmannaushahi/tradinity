import 'package:dartz/dartz.dart';

import '../../data/models/response/instrument_model.dart';


abstract class TradingInstrumentsRepo {
  Future<Either<Exception, List<Instrument>>> fetchInstruments();
}
