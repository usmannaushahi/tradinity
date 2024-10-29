import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradinity/core/di/injection_container.dart';
import 'features/trading_instruments/presentation/cubit/trading_cubit.dart';
import 'features/trading_instruments/presentation/screens/trading_instruments_screen.dart';

Future<void> main() async {
  await initDI();
  runApp(MaterialApp(
      home: BlocProvider(
    create: (context) => TradingCubit(),
    child: const TradingInstrumentsScreen(),
  )));
}
