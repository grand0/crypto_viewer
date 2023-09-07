import 'package:crypto_viewer/redux/settings/settings_actions.dart';
import 'package:crypto_viewer/redux/settings/settings_state.dart';

SettingsState settingsReducer(SettingsState state, action) {
  if (action is ChangeSettingsAction) {
    return SettingsState(
      currency: action.currency ?? state.currency,
      sortBy: action.sortBy ?? state.sortBy,
      descending: action.descending ?? state.descending,
    );
  }
  return state;
}
