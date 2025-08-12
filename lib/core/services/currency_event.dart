import 'package:cashflow/core/models/currency_model.dart';

abstract class CurrencyEvent {
  const CurrencyEvent();
}

class CurrencyLoaded extends CurrencyEvent {
  const CurrencyLoaded();
}

class CurrencyInitialized extends CurrencyEvent {
  const CurrencyInitialized();
}

class CurrencySelected extends CurrencyEvent {
  final CurrencyModel currency;

  const CurrencySelected({
    required this.currency,
  });
}