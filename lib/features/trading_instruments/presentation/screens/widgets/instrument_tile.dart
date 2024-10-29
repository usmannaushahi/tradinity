import 'package:flutter/material.dart';
import '../../../data/models/response/price_model.dart';

class InstrumentTile extends StatelessWidget {
  final Price price;

  const InstrumentTile({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        price.symbol,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(price.name ?? 'Unknown'),
      trailing: _buildPriceIndicator(),
    );
  }

  Widget _buildPriceIndicator() {
    Color priceColor;
    IconData? priceIcon;

    if (price.hasIncreased) {
      priceColor = Colors.green;
      priceIcon = Icons.arrow_upward;
    } else if (price.hasDecreased) {
      priceColor = Colors.red;
      priceIcon = Icons.arrow_downward;
    } else {
      priceColor = Colors.black;
      priceIcon = null; // No icon if price is unchanged
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (priceIcon != null) ...[
          Icon(
            priceIcon,
            color: priceColor,
            size: 18,
          ),
          const SizedBox(width: 4), // Small spacing between icon and price
        ],
        Text(
          price.price != null ? price.price.toString() : 'Loading...',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: priceColor,
          ),
        ),
      ],
    );
  }
}
