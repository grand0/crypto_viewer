import 'dart:convert';

import 'package:crypto_viewer/models/coin.dart';
import 'package:crypto_viewer/models/coin_search_result.dart';
import 'package:crypto_viewer/models/currency.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api.dart';

class GeckoApi extends Api {
  static const String _apiUrl = "https://api.coingecko.com/api/v3";

  @override
  Future<List<Coin>> fetchCoins(List<String> ids) async {
    final futures = <Future<Coin>>[];
    for (final id in ids) {
      futures.add(_coinById(id));
    }
    List<Coin> coins = await Future.wait(futures);
    if (kDebugMode) {
      print(coins);
    }
    return coins;
  }

  @override
  Future<List<CoinSearchResult>> search(String query) {
    if (query.isEmpty) {
      return _coins();
    } else {
      return _search(query);
    }
  }

  Future<Coin> _coinById(String id) async {
    final json = await _apiCall(
            "coins/$id?tickers=false&community_data=false&developer_data=false&sparkline=true")
        as Map;
    final castedJson = json.cast<String, dynamic>();
    final result = _parseCoin(castedJson);
    return result;
  }

  Future<List<CoinSearchResult>> _coins() async {
    final json = await _apiCall("coins") as List;
    final castedJson = json.cast<Map<String, dynamic>>();
    final results = castedJson.map((e) => _parseSearchResultFromCoinJson(e)).toList();
    return results;
  }

  Future<List<CoinSearchResult>> _search(String query) async {
    final json = (await _apiCall("search?query=$query")) as Map;
    final castedJson = json.cast<String, List>();
    final coins = castedJson['coins']!;
    final castedCoins = coins.cast<Map<String, dynamic>>();
    final results = castedCoins.map((e) => _parseSearchResult(e)).toList();
    return results;
  }

  Coin _parseCoin(Map<String, dynamic> json) {
    final uncastedJson = json['market_data']['current_price'] as Map;
    final jsonPrices = uncastedJson.cast<String, double>();
    Map<Currency, double> prices = {};
    for (final s in jsonPrices.keys) {
      try {
        final c = Currency.values.byName(s.toLowerCase());
        prices[c] = jsonPrices[s]!;
      } catch (_) {
        // byName threw => currency not found, that's fine
      }
    }
    return Coin(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      thumbUrl: json['image']['thumb'],
      largeUrl: json['image']['large'],
      prices: prices,
      priceChangePercentage24h: json['market_data']
          ['price_change_percentage_24h'] ?? 100,
      priceChangePercentage7d: json['market_data']
      ['price_change_percentage_7d'] ?? 100,
      sparkline: (json['market_data']['sparkline_7d']['price'] as List).cast<double>(),
      lastUpdated: DateTime.parse(json['market_data']['last_updated']),
    );
  }

  CoinSearchResult _parseSearchResultFromCoinJson(Map<String, dynamic> json) =>
      CoinSearchResult(
        id: json['id'],
        name: json['name'],
        symbol: json['symbol'],
        thumbUrl: json['image']['thumb'],
      );

  CoinSearchResult _parseSearchResult(Map<String, dynamic> json) =>
      CoinSearchResult(
        id: json['id'],
        name: json['name'],
        symbol: json['symbol'],
        thumbUrl: json['thumb'],
      );

  Future<dynamic> _apiCall(String path) async {
    final url = Uri.parse("$_apiUrl/$path");
    final response = await http.get(url);
    if (response.statusCode != 200) {
      String error = "Unknown error";
      switch (response.statusCode) {
        case 429:
          error = "Rate limit";
      }
      return Future.error("$error (${response.statusCode})");
    }
    return jsonDecode(response.body);
  }
}
