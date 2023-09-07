import 'package:crypto_viewer/redux/search/search_actions.dart';
import 'package:crypto_viewer/redux/search/search_state.dart';

SearchState searchReducer(SearchState state, action) {
  if (action is SearchAction) {
    return SearchState(results: state.results, isFetching: true);
  } else if (action is SearchSuccessAction) {
    return SearchState(results: action.coins);
  } else if (action is SearchFailAction) {
    return SearchState(results: [], error: action.error);
  }
  return state;
}