import 'package:crypto_viewer/redux/coins/coins_actions.dart';
import 'package:redux/redux.dart';
import 'package:crypto_viewer/app.dart' as app;

import '../app/app_state.dart';

void fetchCoinsMiddleware(Store<AppState> store, action, NextDispatcher next) {
  if (action is CoinsFetchAction) {
    final List<String>? ids = app.prefs.coinsIds;
    if (ids != null && ids.isNotEmpty) {
      app.api
          .fetchCoins(ids)
          .then((coins) => store.dispatch(CoinsFetchSuccessAction(coins)))
          .catchError((error) =>
              store.dispatch(CoinsFetchFailAction(error.toString())));
      next(action);
    } else {
      store.dispatch(const CoinsFetchSuccessAction([]));
    }
  } else {
    next(action);
  }
}
