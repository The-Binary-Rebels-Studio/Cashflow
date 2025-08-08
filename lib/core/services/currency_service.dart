import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../models/currency_model.dart';
import '../database/database_service.dart';

@singleton
class CurrencyService extends Cubit<CurrencyModel> {
  final DatabaseService _databaseService;

  CurrencyService(this._databaseService) : super(
    const CurrencyModel(
      code: 'IDR',
      name: 'Indonesian Rupiah',
      country: 'Indonesia',
      symbol: 'Rp',
    ),
  );

  CurrencyModel get selectedCurrency => state;

  Future<void> loadSavedCurrency() async {
    final currencyCode = await _databaseService.getString('currency_code');
    
    if (currencyCode != null) {
      final currency = CurrencyData.getCurrencyByCode(currencyCode);
      if (currency != null) {
        emit(currency);
      }
    }
  }

  Future<void> initializeService() async {
    await loadSavedCurrency();
  }

  Future<void> setSelectedCurrency(CurrencyModel currency) async {
    await _databaseService.setString('currency_code', currency.code);
    emit(currency);
  }

  String formatAmount(double amount, {bool showSymbol = true, CurrencyModel? currency}) {
    final currentCurrency = currency ?? state;

    final formattedAmount = amount.abs().toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    if (!showSymbol) return formattedAmount;

    final symbol = currentCurrency.symbol;
    final isPositive = amount >= 0;
    
    return isPositive ? '+$symbol $formattedAmount' : '-$symbol $formattedAmount';
  }
}