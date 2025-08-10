import 'package:injectable/injectable.dart';
import 'package:cashflow/features/onboarding/domain/entities/onboarding_settings.dart';
import 'package:cashflow/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:cashflow/features/localization/domain/usecases/change_locale.dart';

@injectable
class SaveOnboardingSettings {
  final OnboardingRepository _onboardingRepository;
  final ChangeLocale _changeLocale;

  SaveOnboardingSettings(this._onboardingRepository, this._changeLocale);

  Future<void> call(OnboardingSettings settings) async {
    // Complete onboarding first
    await _onboardingRepository.completeOnboarding();
    
    // Save locale and apply it immediately
    await _changeLocale(settings.selectedLocale.locale);
  }
}