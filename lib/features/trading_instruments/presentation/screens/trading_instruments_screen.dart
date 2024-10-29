import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradinity/features/trading_instruments/presentation/screens/widgets/instruments_list.dart';
import '../cubit/trading_cubit.dart';
import '../cubit/trading_state.dart';

class TradingInstrumentsScreen extends StatefulWidget {
  const TradingInstrumentsScreen({super.key});

  @override
  State<TradingInstrumentsScreen> createState() =>
      _TradingInstrumentsScreenState();
}

class _TradingInstrumentsScreenState extends State<TradingInstrumentsScreen> {
  late TradingCubit cubit;

  @override
  void initState() {
    cubit = context.read<TradingCubit>();
    cubit.fetchInstruments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trading Instruments')),
      body: BlocBuilder<TradingCubit, TradingState>(
        builder: (context, state) {
          if (state is PriceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is InstrumentsLoaded || state is PriceUpdated) {
            final prices = (state as dynamic).prices;
            return InstrumentsList(prices: prices);
          } else if (state is PriceError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unexpected state.'));
          }
        },
      ),
    );
  }
}
