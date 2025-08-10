import 'package:injectable/injectable.dart';
import 'package:cashflow/features/onboarding/domain/entities/onboarding_status.dart';
import 'package:cashflow/features/onboarding/domain/repositories/onboarding_repository.dart';

@injectable
class GetOnboardingStatus {
  final OnboardingRepository repository;
  
  const GetOnboardingStatus(this.repository);
  
  Future<OnboardingStatus> call() async {
    return await repository.getOnboardingStatus();
  }
}