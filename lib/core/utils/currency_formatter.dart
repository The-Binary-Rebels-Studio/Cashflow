import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class CurrencyFormatter {
  
  static String _formatDecimal(double value, int decimals) {
    final formatted = value.toStringAsFixed(decimals);
    
    return formatted.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
  
  
  static String _formatAmount(double amount, BuildContext context, {bool highPrecision = false}) {
    final l10n = AppLocalizations.of(context)!;
    final absAmount = amount.abs();
    
    if (absAmount >= 1000000000) {
      
      final decimals = highPrecision ? 2 : 1;
      final value = absAmount / 1000000000;
      return '${_formatDecimal(value, decimals)} ${l10n.currencyBillions}';
    } else if (absAmount >= 1000000) {
      
      final decimals = highPrecision ? 2 : 1;
      final value = absAmount / 1000000;
      return '${_formatDecimal(value, decimals)} ${l10n.currencyMillions}';
    } else if (absAmount >= 1000) {
      
      final decimals = highPrecision ? 1 : 0;
      final value = absAmount / 1000;
      return '${_formatDecimal(value, decimals)} ${l10n.currencyThousands}';
    } else {
      
      return NumberFormat('#,###', 'id_ID').format(absAmount);
    }
  }
  
  
  static String formatForHomeScreen(double amount, BuildContext context) {
    final isNegative = amount < 0;
    final sign = isNegative ? '-' : '';
    final formattedAmount = _formatAmount(amount, context, highPrecision: true);
    return '$sign$formattedAmount';
  }
  
  
  static String formatCompact(double amount, BuildContext context) {
    final isNegative = amount < 0;
    final sign = isNegative ? '-' : '';
    final formattedAmount = _formatAmount(amount, context, highPrecision: false);
    return '$sign$formattedAmount';
  }
  
  
  static String formatFull(double amount) {
    return NumberFormat('#,###', 'id_ID').format(amount);
  }
  
  
  
  static String formatWithSymbol(double amount, String currencySymbol, BuildContext context, {bool showSign = true, bool useHomeFormat = false}) {
    final isNegative = amount < 0;
    final sign = showSign ? (isNegative ? '-' : '+') : '';
    
    
    final formattedAmount = _formatAmount(amount.abs(), context, highPrecision: useHomeFormat);
    
    return '$sign$currencySymbol$formattedAmount';
  }
}