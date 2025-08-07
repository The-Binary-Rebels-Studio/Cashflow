import '../entities/onboarding_status.dart';

abstract class OnboardingRepository {
  Future<OnboardingStatus> getOnboardingStatus();
  Future<void> completeOnboarding();
  Future<void> resetOnboarding();
}