import 'package:crypto_viewer/api/api.dart';
import 'package:crypto_viewer/api/gecko_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Api get api => GeckoApi();
late SharedPreferences prefs;

extension SharedPreferenciesGetters on SharedPreferences {
  List<String>? get coinsIds => prefs.getStringList('coins_ids');
  Future<bool> addCoinId(String id) => prefs.setStringList('coins_ids', (prefs.coinsIds ?? []) + [id]);
  Future<bool> removeCoinId(String id) => prefs.setStringList('coins_ids', (prefs.coinsIds ?? [])..remove(id));
}