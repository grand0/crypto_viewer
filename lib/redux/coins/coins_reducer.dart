import 'package:crypto_viewer/redux/coins/coins_actions.dart';
import 'package:crypto_viewer/redux/coins/coins_state.dart';

CoinsState coinsReducer(CoinsState state, action) {
  if (action is CoinsFetchAction) {
    return CoinsState(coins: state.coins, isFetching: true);
  } else if (action is CoinsFetchSuccessAction) {
    return CoinsState(coins: action.coins);
  } else if (action is CoinsFetchFailAction) {
    return CoinsState(coins: [], error: action.error);
  }
  return state;
}