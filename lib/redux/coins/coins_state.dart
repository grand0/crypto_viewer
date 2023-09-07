import '../../models/coin.dart';

class CoinsState {
  final List<Coin> coins;
  final bool isFetching;
  final String? error;

  const CoinsState({
    required this.coins,
    this.isFetching = false,
    this.error,
  });

  CoinsState.initial()
      : coins = [],
        isFetching = false,
        error = null;
}
