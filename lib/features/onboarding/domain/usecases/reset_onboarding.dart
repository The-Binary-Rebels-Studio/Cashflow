import 'package:injectable/injectable.dart';
import 'package:cashflow/features/onboarding/domain/repositories/onboarding_repository.dart';

@injectable
class ResetOnboarding {
  final OnboardingRepository repository;
  
  const ResetOnboarding(this.repository);
  
  Future<void> call() async {
    return await repository.resetOnboarding();
  }
}