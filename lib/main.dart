import 'package:crypto_viewer/redux/coins/coins_actions.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'redux/app/app_state.dart';
import 'redux/store.dart';
import 'pages/home_page.dart';
import 'theme.dart' as theme;
import 'app.dart' as app;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app.prefs = await SharedPreferences.getInstance();

  Store<AppState> store = createStore();
  store.dispatch(CoinsFetchAction());

  runApp(StoreProvider<AppState>(
    store: store,
    child: MaterialApp(
      title: "Crypto Viewer",
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (_) => const HomePage(),
      },
    ),
  ));
}
