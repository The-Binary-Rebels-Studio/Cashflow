import 'package:get_it/get_it.dart';
import '../models/currency_model.dart';
import '../database/database_service.dart';

class CurrencyService {
  DatabaseService? _databaseService;
  CurrencyModel? _cachedCurrency;

  DatabaseService get databaseService {
    _databaseService ??= GetIt.instance<DatabaseService>();
    return _databaseService!;
  }

  Future<CurrencyModel> getSelectedCurrency() async {
    if (_cachedCurrency != null) {
      return _cachedCurrency!;
    }

    final currencyCode = await databaseService.getString('currency_code');
    
    if (currencyCode != null) {
      _cachedCurrency = CurrencyData.getCurrencyByCode(currencyCode);
    }
    
    _cachedCurrency ??= const CurrencyModel(
      code: 'IDR',
      name: 'Indonesian Rupiah',
      country: 'Indonesia',
      symbol: 'Rp',
    );
    
    return _cachedCurrency!;
  }

  Future<void> initializeService() async {
    await getSelectedCurrency();
  }

  Future<void> setSelectedCurrency(CurrencyModel currency) async {
    await databaseService.setString('currency_code', currency.code);
    _cachedCurrency = currency;
  }

  String formatAmount(double amount, {bool showSymbol = true}) {
    final currency = _cachedCurrency ?? const CurrencyModel(
      code: 'IDR',
      name: 'Indonesian Rupiah',
      country: 'Indonesia',
      symbol: 'Rp',
    );

    final formattedAmount = amount.abs().toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    if (!showSymbol) return formattedAmount;

    final symbol = currency.symbol;
    final isPositive = amount >= 0;
    
    return isPositive ? '+$symbol $formattedAmount' : '-$symbol $formattedAmount';
  }

  void clearCache() {
    _cachedCurrency = null;
  }
}