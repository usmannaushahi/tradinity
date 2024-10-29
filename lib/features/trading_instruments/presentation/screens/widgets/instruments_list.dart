import 'package:flutter/material.dart';

import '../../../data/models/response/price_model.dart';
import 'instrument_tile.dart';

class InstrumentsList extends StatelessWidget {
  final List<Price> prices;

  const InstrumentsList({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: prices.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final price = prices[index];
        return InstrumentTile(price: price);
      },
    );
  }
}
