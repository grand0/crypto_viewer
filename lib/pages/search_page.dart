import 'package:crypto_viewer/models/coin_search_result.dart';
import 'package:crypto_viewer/redux/coins/coins_actions.dart';
import 'package:crypto_viewer/redux/search/search_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../redux/app/app_state.dart';
import '../redux/search/search_state.dart';
import '../app.dart' as app;

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key, required this.closeContainer}) : super(key: key);

  final VoidCallback closeContainer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StoreConnector<AppState, void Function(String)>(
          converter: (store) => (query) => store.dispatch(SearchAction(query)),
          builder: (context, search) => TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search...',
            ),
            onChanged: (text) {
              search(text);
            },
          ),
        ),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: closeContainer,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: StoreConnector<AppState, SearchState>(
        converter: (store) => store.state.searchState,
        builder: (context, state) {
          if (state.isFetching) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text("ERROR: ${state.error}"));
          } else {
            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final result = state.results[index];
                return SearchResultTile(result: result);
              },
            );
          }
        },
      ),
    );
  }
}

class SearchResultTile extends StatefulWidget {
  const SearchResultTile({Key? key, required this.result}) : super(key: key);

  final CoinSearchResult result;

  @override
  State<SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<SearchResultTile> {
  Future<bool>? future;

  @override
  Widget build(BuildContext context) {
    Widget trailing;
    if (future != null) {
      trailing = const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(),
      );
    } else if ((app.prefs.coinsIds ?? []).contains(widget.result.id)) {
      trailing = IconButton(
        onPressed: () {
          setState(() {
            future = app.prefs
                .removeCoinId(widget.result.id)
                .whenComplete(() => setState(() => future = null));
          });
        },
        icon: const Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      );
    } else {
      trailing = IconButton(
        onPressed: () {
          setState(() {
            future = app.prefs
                .addCoinId(widget.result.id)
                .whenComplete(() => setState(() => future = null));
          });
        },
        icon: const Icon(Icons.star_border),
      );
    }

    return ListTile(
      title: Text(widget.result.name),
      subtitle: Text(widget.result.symbol.toUpperCase()),
      leading: Image.network(widget.result.thumbUrl),
      trailing: trailing,
    );
  }
}
