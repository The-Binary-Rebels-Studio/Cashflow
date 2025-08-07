import 'package:cashflow/core/models/currency_model.dart';
import 'package:cashflow/core/models/locale_model.dart';

class OnboardingSettings {
  final CurrencyModel selectedCurrency;
  final LocaleModel selectedLocale;

  const OnboardingSettings({
    required this.selectedCurrency,
    required this.selectedLocale,
  });

  OnboardingSettings copyWith({
    CurrencyModel? selectedCurrency,
    LocaleModel? selectedLocale,
  }) {
    return OnboardingSettings(
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      selectedLocale: selectedLocale ?? this.selectedLocale,
    );
  }
}