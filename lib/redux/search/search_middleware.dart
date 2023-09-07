import 'package:crypto_viewer/redux/app/app_state.dart';
import 'package:crypto_viewer/redux/search/search_actions.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:crypto_viewer/app.dart' as app;

Stream<dynamic> searchEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .whereType<SearchAction>()
      .debounceTime(const Duration(milliseconds: 800))
      .switchMap((action) {
        return Stream.fromFuture(
            app.api.search(action.query).then(
                  (results) {
                    print('success ${action.query}');
                    return SearchSuccessAction(results);
                  },
                  onError: (error) {
                    print('$error');
                    return SearchFailAction(error.toString());
                  },
                ),
          );
      });
}
