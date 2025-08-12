import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/core/database/database_service.dart';
import 'package:cashflow/core/services/currency_event.dart';

@singleton
class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyModel> {
  final DatabaseService _databaseService;

  CurrencyBloc(this._databaseService) : super(
    const CurrencyModel(
      code: 'IDR',
      name: 'Indonesian Rupiah',
      country: 'Indonesia',
      symbol: 'Rp',
    ),
  ) {
    on<CurrencyLoaded>(_onLoaded);
    on<CurrencyInitialized>(_onInitialized);
    on<CurrencySelected>(_onSelected);
  }

  CurrencyModel get selectedCurrency => state;

  Future<void> _onLoaded(
    CurrencyLoaded event,
    Emitter<CurrencyModel> emit,
  ) async {
    final currencyCode = await _databaseService.getString('currency_code');
    
    if (currencyCode != null) {
      final currency = CurrencyData.getCurrencyByCode(currencyCode);
      if (currency != null) {
        emit(currency);
      }
    }
  }

  Future<void> _onInitialized(
    CurrencyInitialized event,
    Emitter<CurrencyModel> emit,
  ) async {
    add(const CurrencyLoaded());
  }

  Future<void> _onSelected(
    CurrencySelected event,
    Emitter<CurrencyModel> emit,
  ) async {
    await _databaseService.setString('currency_code', event.currency.code);
    emit(event.currency);
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