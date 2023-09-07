import 'package:equatable/equatable.dart';

class CoinSearchResult extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final String thumbUrl;

  const CoinSearchResult({
    required this.id,
    required this.name,
    required this.symbol,
    required this.thumbUrl,
  });

  @override
  List<Object?> get props => [id, name, symbol, thumbUrl];
}
