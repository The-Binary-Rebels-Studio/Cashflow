import 'package:equatable/equatable.dart';

class CurrencyModel extends Equatable {
  final String code;
  final String name;
  final String country;
  final String symbol;

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.country,
    required this.symbol,
  });

  @override
  List<Object?> get props => [code, name, country, symbol];
}

class CurrencyData {
  static const List<CurrencyModel> currencies = [
    CurrencyModel(code: 'USD', name: 'US Dollar', country: 'United States', symbol: '\$'),
    CurrencyModel(code: 'EUR', name: 'Euro', country: 'European Union', symbol: '€'),
    CurrencyModel(code: 'IDR', name: 'Indonesian Rupiah', country: 'Indonesia', symbol: 'Rp'),
    CurrencyModel(code: 'MYR', name: 'Malaysian Ringgit', country: 'Malaysia', symbol: 'RM'),
    CurrencyModel(code: 'SGD', name: 'Singapore Dollar', country: 'Singapore', symbol: 'S\$'),
    CurrencyModel(code: 'GBP', name: 'British Pound', country: 'United Kingdom', symbol: '£'),
    CurrencyModel(code: 'JPY', name: 'Japanese Yen', country: 'Japan', symbol: '¥'),
    CurrencyModel(code: 'CNY', name: 'Chinese Yuan', country: 'China', symbol: '¥'),
    CurrencyModel(code: 'AUD', name: 'Australian Dollar', country: 'Australia', symbol: 'A\$'),
    CurrencyModel(code: 'CAD', name: 'Canadian Dollar', country: 'Canada', symbol: 'C\$'),
    CurrencyModel(code: 'CHF', name: 'Swiss Franc', country: 'Switzerland', symbol: 'CHF'),
    CurrencyModel(code: 'INR', name: 'Indian Rupee', country: 'India', symbol: '₹'),
    CurrencyModel(code: 'KRW', name: 'Korean Won', country: 'South Korea', symbol: '₩'),
    CurrencyModel(code: 'THB', name: 'Thai Baht', country: 'Thailand', symbol: '฿'),
    CurrencyModel(code: 'PHP', name: 'Philippine Peso', country: 'Philippines', symbol: '₱'),
    CurrencyModel(code: 'VND', name: 'Vietnamese Dong', country: 'Vietnam', symbol: '₫'),
    CurrencyModel(code: 'BRL', name: 'Brazilian Real', country: 'Brazil', symbol: 'R\$'),
    CurrencyModel(code: 'ARS', name: 'Argentine Peso', country: 'Argentina', symbol: '\$'),
    CurrencyModel(code: 'CLP', name: 'Chilean Peso', country: 'Chile', symbol: '\$'),
    CurrencyModel(code: 'COP', name: 'Colombian Peso', country: 'Colombia', symbol: '\$'),
    CurrencyModel(code: 'MXN', name: 'Mexican Peso', country: 'Mexico', symbol: '\$'),
    CurrencyModel(code: 'ZAR', name: 'South African Rand', country: 'South Africa', symbol: 'R'),
    CurrencyModel(code: 'EGP', name: 'Egyptian Pound', country: 'Egypt', symbol: '£'),
    CurrencyModel(code: 'NGN', name: 'Nigerian Naira', country: 'Nigeria', symbol: '₦'),
    CurrencyModel(code: 'TRY', name: 'Turkish Lira', country: 'Turkey', symbol: '₺'),
    CurrencyModel(code: 'RUB', name: 'Russian Ruble', country: 'Russia', symbol: '₽'),
    CurrencyModel(code: 'PLN', name: 'Polish Zloty', country: 'Poland', symbol: 'zł'),
    CurrencyModel(code: 'CZK', name: 'Czech Koruna', country: 'Czech Republic', symbol: 'Kč'),
    CurrencyModel(code: 'HUF', name: 'Hungarian Forint', country: 'Hungary', symbol: 'Ft'),
    CurrencyModel(code: 'SEK', name: 'Swedish Krona', country: 'Sweden', symbol: 'kr'),
    CurrencyModel(code: 'NOK', name: 'Norwegian Krone', country: 'Norway', symbol: 'kr'),
    CurrencyModel(code: 'DKK', name: 'Danish Krone', country: 'Denmark', symbol: 'kr'),
    CurrencyModel(code: 'NZD', name: 'New Zealand Dollar', country: 'New Zealand', symbol: 'NZ\$'),
    CurrencyModel(code: 'HKD', name: 'Hong Kong Dollar', country: 'Hong Kong', symbol: 'HK\$'),
    CurrencyModel(code: 'TWD', name: 'Taiwan Dollar', country: 'Taiwan', symbol: 'NT\$'),
  ];

  static CurrencyModel? getCurrencyByCode(String code) {
    try {
      return currencies.firstWhere((currency) => currency.code == code);
    } catch (e) {
      return null;
    }
  }
}