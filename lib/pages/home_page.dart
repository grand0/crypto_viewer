import 'package:animations/animations.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_viewer/models/currency.dart';
import 'package:crypto_viewer/models/sort_by.dart';
import 'package:crypto_viewer/pages/search_page.dart';
import 'package:crypto_viewer/redux/coins/coins_actions.dart';
import 'package:crypto_viewer/redux/settings/settings_actions.dart';
import 'package:declarative_refresh_indicator/declarative_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../models/coin.dart';
import '../redux/app/app_state.dart';
import '../redux/coins/coins_state.dart';
import '../redux/settings/settings_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            StoreConnector<AppState, Map<String, dynamic>>(
              converter: (Store<AppState> store) => {
                'state': store.state.coinsState,
                'settings': store.state.settingsState,
                'refresh': () => store.dispatch(CoinsFetchAction())
              },
              builder: (context, map) {
                final state = map['state']! as CoinsState;
                final settings = map['settings']! as SettingsState;
                final refresh = map['refresh']! as VoidCallback;
                if (state.coins.isNotEmpty) {
                  List<Coin> coins = state.coins;
                  switch (settings.sortBy) {
                    case SortBy.alphabet:
                      coins.sort((a, b) => a.name.compareTo(b.name));
                      break;
                    case SortBy.price:
                      coins.sort((a, b) => (a.prices[settings.currency] ?? 0)
                          .compareTo(b.prices[settings.currency] ?? 0));
                      break;
                    case SortBy.priceChange:
                      coins.sort((a, b) => a.priceChangePercentage7d
                          .compareTo(b.priceChangePercentage7d));
                      break;
                  }
                  if (settings.descending) {
                    coins = coins.reversed.toList();
                  }
                  return DeclarativeRefreshIndicator(
                    displacement: 90,
                    refreshing: state.isFetching,
                    onRefresh: refresh,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: ListView.separated(
                        itemCount: coins.length + 1,
                        itemBuilder: (_, index) {
                          if (index == 0) {
                            return const SizedBox(height: 80);
                          }
                          final coin = coins[index - 1];
                          return _coinCard(context, coin);
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                      ),
                    ),
                  );
                } else if (state.isFetching) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.warning, size: 72),
                        Text("Error",
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(state.error!, textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        ElevatedButton(
                            onPressed: refresh, child: const Text('Retry')),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.playlist_add, size: 72),
                        const Text("Empty"),
                        ElevatedButton(
                          onPressed: refresh,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            Container(
              height: 80,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Theme.of(context).colorScheme.background,
                    Theme.of(context).colorScheme.background.withOpacity(0),
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OpenContainer(
                closedBuilder: (_, openContainer) =>
                    SearchBar(openContainer: openContainer),
                openBuilder: (_, closeContainer) =>
                    SearchPage(closeContainer: closeContainer),
                tappable: false,
                closedColor: Theme.of(context).canvasColor,
                openColor: Theme.of(context).canvasColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coinCard(
      BuildContext context, Coin coin) {
    final upwards = coin.priceChangePercentage7d > 0;
    final color = upwards ? Colors.green : Colors.red;
    final icon = upwards ? Icons.arrow_upward : Icons.arrow_downward;

    return Card(
      margin: const EdgeInsets.all(0),
      child: Stack(
        children: [
          Sparkline(
            data: coin.sparkline,
            lineGradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                color.shade200,
                color.shade200,
              ],
            ),
            fillMode: FillMode.below,
            fillGradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                color.shade200.withOpacity(0),
                color.shade200,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListTile(
              title: Text(coin.name),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coin.symbol.toUpperCase()),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StoreConnector<AppState, Currency>(
                        converter: (store) =>
                            store.state.settingsState.currency,
                        builder: (_, currency) => Text(
                            '${currency.symbol}${coin.prices[currency]}'),
                      ),
                      const SizedBox(width: 8),
                      Icon(icon, color: color),
                      const SizedBox(width: 4),
                      Text(
                        "${coin.priceChangePercentage7d.toStringAsFixed(2)}%",
                        style: TextStyle(color: color),
                      ),
                    ],
                  )
                ],
              ),
              leading: Image.network(coin.thumbUrl),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key, required this.openContainer}) : super(key: key);

  final VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      elevation: 2,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: openContainer,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.search),
              const Text("Search..."),
              SizedBox(
                height: 24,
                width: 24,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.settings),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return StoreConnector<AppState, Map<String, dynamic>>(
                        converter: (store) => {
                          'state': store.state.settingsState,
                          'apply': (currency, sortBy, descending) =>
                              store.dispatch(ChangeSettingsAction(
                                currency: currency,
                                sortBy: sortBy,
                                descending: descending,
                              )),
                        },
                        builder: (_, map) {
                          final state = map['state'] as SettingsState;
                          final apply = map['apply'] as void Function(
                              Currency, SortBy, bool);
                          return SettingsSheet(
                            initialCurrency: state.currency,
                            initialSortBy: state.sortBy,
                            initialDescending: state.descending,
                            apply: apply,
                          );
                        },
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsSheet extends StatefulWidget {
  const SettingsSheet({
    Key? key,
    required this.initialCurrency,
    required this.initialSortBy,
    required this.initialDescending,
    required this.apply,
  }) : super(key: key);

  final Currency initialCurrency;
  final SortBy initialSortBy;
  final bool initialDescending;
  final void Function(Currency, SortBy, bool) apply;

  @override
  State<SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<SettingsSheet> {
  late Currency currency;
  late SortBy sortBy;
  late bool descending;

  @override
  void initState() {
    super.initState();
    currency = widget.initialCurrency;
    sortBy = widget.initialSortBy;
    descending = widget.initialDescending;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Currency"),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: Currency.values.map((e) {
                return OutlinedButton(
                  onPressed: () => setState(() => currency = e),
                  style: e == currency
                      ? OutlinedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        )
                      : null,
                  child: Text(e.name.toUpperCase()),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Sort by"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: SortBy.values.map((e) {
              return OutlinedButton(
                onPressed: () => setState(() => sortBy = e),
                style: e == sortBy
                    ? OutlinedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      )
                    : null,
                child: Text(e.displayName),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text("Order"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => descending = true),
                style: descending
                    ? OutlinedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      )
                    : null,
                child: const Icon(Icons.arrow_downward),
              ),
              OutlinedButton(
                onPressed: () => setState(() => descending = false),
                style: !descending
                    ? OutlinedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      )
                    : null,
                child: const Icon(Icons.arrow_upward),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                widget.apply(currency, sortBy, descending);
                Navigator.pop(context);
              },
              child: const Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }
}
