import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cashflow/l10n/app_localizations.dart';

class CurrencyFormatter {
  /// Helper function to format decimal values without unnecessary .0
  static String _formatDecimal(double value, int decimals) {
    final formatted = value.toStringAsFixed(decimals);
    // Remove trailing zeros and unnecessary decimal point
    return formatted.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
  
  /// Core formatting logic - unified for consistency
  static String _formatAmount(double amount, BuildContext context, {bool highPrecision = false}) {
    final l10n = AppLocalizations.of(context)!;
    final absAmount = amount.abs();
    
    if (absAmount >= 1000000000) {
      // Billions - use more precision for home screen
      final decimals = highPrecision ? 2 : 1;
      final value = absAmount / 1000000000;
      return '${_formatDecimal(value, decimals)} ${l10n.currencyBillions}';
    } else if (absAmount >= 1000000) {
      // Millions - use more precision for home screen  
      final decimals = highPrecision ? 2 : 1;
      final value = absAmount / 1000000;
      return '${_formatDecimal(value, decimals)} ${l10n.currencyMillions}';
    } else if (absAmount >= 1000) {
      // Thousands - use 1 decimal for home, 0 for compact
      final decimals = highPrecision ? 1 : 0;
      final value = absAmount / 1000;
      return '${_formatDecimal(value, decimals)} ${l10n.currencyThousands}';
    } else {
      // Below 1000 - show full amount with thousand separators
      return NumberFormat('#,###', 'id_ID').format(absAmount);
    }
  }
  
  /// Format currency for home screen with higher precision
  static String formatForHomeScreen(double amount, BuildContext context) {
    final isNegative = amount < 0;
    final sign = isNegative ? '-' : '';
    final formattedAmount = _formatAmount(amount, context, highPrecision: true);
    return '$sign$formattedAmount';
  }
  
  /// Format currency for compact display (same as home now for consistency)
  static String formatCompact(double amount, BuildContext context) {
    final isNegative = amount < 0;
    final sign = isNegative ? '-' : '';
    final formattedAmount = _formatAmount(amount, context, highPrecision: false);
    return '$sign$formattedAmount';
  }
  
  /// Format currency lengkap dengan pemisah ribuan Indonesia
  static String formatFull(double amount) {
    return NumberFormat('#,###', 'id_ID').format(amount);
  }
  
  /// Format dengan currency symbol dan tanda plus/minus
  /// Sekarang menggunakan format yang konsisten untuk semua kasus
  static String formatWithSymbol(double amount, String currencySymbol, BuildContext context, {bool showSign = true, bool useHomeFormat = false}) {
    final isNegative = amount < 0;
    final sign = showSign ? (isNegative ? '-' : '+') : '';
    
    // Use unified formatting logic
    final formattedAmount = _formatAmount(amount.abs(), context, highPrecision: useHomeFormat);
    
    return '$sign$currencySymbol$formattedAmount';
  }
}