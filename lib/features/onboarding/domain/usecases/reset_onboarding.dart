import 'package:injectable/injectable.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class ResetOnboarding {
  final OnboardingRepository repository;
  
  const ResetOnboarding(this.repository);
  
  Future<void> call() async {
    return await repository.resetOnboarding();
  }
}