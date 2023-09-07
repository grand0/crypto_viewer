import '../../models/coin_search_result.dart';

class SearchState {
  final List<CoinSearchResult> results;
  final bool isFetching;
  final String? error;

  const SearchState({
    required this.results,
    this.isFetching = false,
    this.error,
  });

  SearchState.initial()
      : results = [],
        isFetching = false,
        error = null;
}
