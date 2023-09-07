import 'package:crypto_viewer/models/currency.dart';
import 'package:crypto_viewer/models/sort_by.dart';

class SettingsState {
  final Currency currency;
  final SortBy sortBy;
  final bool descending;

  const SettingsState({
    required this.currency,
    required this.sortBy,
    required this.descending,
  });

  const SettingsState.initial()
      : currency = Currency.usd,
        sortBy = SortBy.price,
        descending = true;
}
