import 'package:equatable/equatable.dart';

import 'currency.dart';

class Coin extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final String thumbUrl;
  final String largeUrl;
  final Map<Currency, double> prices;
  final double priceChangePercentage24h;
  final double priceChangePercentage7d;
  final List<double> sparkline;
  final DateTime lastUpdated;

  const Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.thumbUrl,
    required this.largeUrl,
    required this.prices,
    required this.priceChangePercentage24h,
    required this.priceChangePercentage7d,
    required this.sparkline,
    required this.lastUpdated,
  });

  /// Returns last 24 entries of sparkline.
  /// If there is less than 24 entries, returns whole sparkline.
  List<double> get strippedSparkline {
    if (sparkline.length >= 24) {
      return sparkline.sublist(sparkline.length - 24);
    } else {
      return sparkline;
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        thumbUrl,
        largeUrl,
        prices,
        priceChangePercentage24h,
        priceChangePercentage7d,
        sparkline,
        lastUpdated,
      ];
}
