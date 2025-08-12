import 'package:cashflow/features/onboarding/domain/entities/onboarding_settings.dart';

abstract class OnboardingEvent {
  const OnboardingEvent();
}

class OnboardingStatusChecked extends OnboardingEvent {
  const OnboardingStatusChecked();
}

class OnboardingCompletionRequested extends OnboardingEvent {
  const OnboardingCompletionRequested();
}

class OnboardingSettingsSaved extends OnboardingEvent {
  final OnboardingSettings settings;

  const OnboardingSettingsSaved({
    required this.settings,
  });
}

class OnboardingReset extends OnboardingEvent {
  const OnboardingReset();
}