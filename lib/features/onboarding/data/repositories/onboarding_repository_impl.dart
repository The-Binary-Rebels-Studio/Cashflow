import 'package:injectable/injectable.dart';
import '../../domain/entities/onboarding_status.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

@Injectable(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;
  
  const OnboardingRepositoryImpl({
    required this.localDataSource,
  });
  
  @override
  Future<OnboardingStatus> getOnboardingStatus() async {
    final isCompleted = await localDataSource.isOnboardingCompleted();
    return OnboardingStatus(isCompleted: isCompleted);
  }
  
  @override
  Future<void> completeOnboarding() async {
    await localDataSource.setOnboardingCompleted(true);
  }
  
  @override
  Future<void> resetOnboarding() async {
    await localDataSource.setOnboardingCompleted(false);
  }
}