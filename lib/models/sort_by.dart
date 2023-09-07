enum SortBy {
  alphabet('Alphabet'), price('Price'), priceChange('Price change');

  const SortBy(this.displayName);

  final String displayName;
}