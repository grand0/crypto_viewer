import '../../models/currency.dart';
import '../../models/sort_by.dart';

class ChangeSettingsAction {
  final Currency? currency;
  final SortBy? sortBy;
  final bool? descending;

  ChangeSettingsAction({
    this.currency,
    this.sortBy,
    this.descending,
  });
}
