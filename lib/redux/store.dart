import 'package:crypto_viewer/redux/search/search_middleware.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'app/app_reducer.dart';
import 'app/app_state.dart';
import 'coins/coins_middleware.dart';

Store<AppState> createStore() => Store<AppState>(
      appReducer,
      initialState: AppState.initial(),
      middleware: [fetchCoinsMiddleware, EpicMiddleware(searchEpic)],
    );
