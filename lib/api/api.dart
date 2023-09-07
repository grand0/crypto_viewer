import '../models/coin.dart';
import '../models/coin_search_result.dart';

abstract class Api {
  Future<List<Coin>> fetchCoins(List<String> ids);
  Future<List<CoinSearchResult>> search(String query);
}