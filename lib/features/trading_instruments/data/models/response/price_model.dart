class Price {
  final String symbol;
  double? price;
  String? name;

  Price({required this.symbol, this.price, this.name});

  // Additional method to check price change
  bool get hasIncreased => price != null && price! > previousPrice;
  bool get hasDecreased => price != null && price! < previousPrice;

  double previousPrice = 0; // Store previous price for comparison

  // fromJson function to parse incoming price data
  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      symbol: json['s'],
      price: double.tryParse((json['p'] ?? "0.00").toString()),
      name: json['name'],
    );
  }
}
