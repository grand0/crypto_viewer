enum Currency {
  btc("₿"), eth("Ξ"), usd("\$"), eur("€"), rub("₽"), gbp("£");

  const Currency(this.symbol);

  final String symbol;
}