import 'package:crypto_viewer/redux/coins/coins_state.dart';
import 'package:crypto_viewer/redux/search/search_state.dart';
import 'package:crypto_viewer/redux/settings/settings_state.dart';

class AppState {
  final CoinsState coinsState;
  final SearchState searchState;
  final SettingsState settingsState;

  const AppState({
    required this.coinsState,
    required this.searchState,
    required this.settingsState,
  });

  AppState.initial()
      : coinsState = CoinsState.initial(),
        searchState = SearchState.initial(),
        settingsState = const SettingsState.initial();
}
