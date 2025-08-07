import 'package:injectable/injectable.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class CompleteOnboarding {
  final OnboardingRepository repository;
  
  const CompleteOnboarding(this.repository);
  
  Future<void> call() async {
    return await repository.completeOnboarding();
  }
}