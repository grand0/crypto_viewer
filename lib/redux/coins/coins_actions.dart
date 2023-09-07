import '../../models/coin.dart';

class CoinsFetchAction {}

class CoinsFetchSuccessAction {
  final List<Coin> coins;

  const CoinsFetchSuccessAction(this.coins);
}

class CoinsFetchFailAction {
  final String error;

  const CoinsFetchFailAction(this.error);
}