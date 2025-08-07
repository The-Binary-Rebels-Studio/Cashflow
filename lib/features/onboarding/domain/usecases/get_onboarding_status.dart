import 'package:injectable/injectable.dart';
import '../entities/onboarding_status.dart';
import '../repositories/onboarding_repository.dart';

@injectable
class GetOnboardingStatus {
  final OnboardingRepository repository;
  
  const GetOnboardingStatus(this.repository);
  
  Future<OnboardingStatus> call() async {
    return await repository.getOnboardingStatus();
  }
}