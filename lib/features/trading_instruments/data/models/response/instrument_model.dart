class Instrument {
  final String description;
  final String displaySymbol;
  final String symbol;

  Instrument({
    required this.description,
    required this.displaySymbol,
    required this.symbol,
  });

  factory Instrument.fromJson(Map<String, dynamic> json) {
    return Instrument(
      description: json['description'],
      displaySymbol: json['displaySymbol'],
      symbol: json['symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'displaySymbol': displaySymbol,
      'symbol': symbol,
    };
  }

  static List<Instrument> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Instrument.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Instrument> instruments) {
    return instruments.map((instrument) => instrument.toJson()).toList();
  }
}
