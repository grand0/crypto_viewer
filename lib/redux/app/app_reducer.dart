import 'package:crypto_viewer/redux/coins/coins_reducer.dart';
import 'package:crypto_viewer/redux/search/search_reducer.dart';
import 'package:crypto_viewer/redux/settings/settings_reducer.dart';

import 'app_state.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    coinsState: coinsReducer(state.coinsState, action),
    searchState: searchReducer(state.searchState, action),
    settingsState: settingsReducer(state.settingsState, action),
  );
}
