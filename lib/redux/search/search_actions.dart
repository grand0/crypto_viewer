import 'package:crypto_viewer/models/coin_search_result.dart';

class SearchAction {
  final String query;

  const SearchAction(this.query);
}

class SearchSuccessAction {
  final List<CoinSearchResult> coins;

  const SearchSuccessAction(this.coins);
}

class SearchFailAction {
  final String? error;

  const SearchFailAction(this.error);
}