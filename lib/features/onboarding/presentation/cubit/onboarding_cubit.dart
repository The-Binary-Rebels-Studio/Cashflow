import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_onboarding_status.dart';
import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/reset_onboarding.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final GetOnboardingStatus _getOnboardingStatus;
  final CompleteOnboarding _completeOnboarding;
  final ResetOnboarding _resetOnboarding;

  OnboardingCubit(
    this._getOnboardingStatus,
    this._completeOnboarding,
    this._resetOnboarding,
  ) : super(OnboardingInitial());

  Future<void> checkOnboardingStatus() async {
    try {
      emit(OnboardingLoading());
      
      final status = await _getOnboardingStatus();
      
      emit(OnboardingStatusLoaded(
        isCompleted: status.isCompleted,
      ));
    } catch (e) {
      emit(OnboardingError(
        message: 'Failed to check onboarding status: ${e.toString()}',
      ));
    }
  }

  Future<void> completeOnboarding() async {
    try {
      emit(OnboardingLoading());
      
      await _completeOnboarding();
      
      emit(OnboardingCompleted());
    } catch (e) {
      emit(OnboardingError(
        message: 'Failed to complete onboarding: ${e.toString()}',
      ));
    }
  }

  Future<void> resetOnboarding() async {
    try {
      emit(OnboardingLoading());
      
      await _resetOnboarding();
      
      emit(OnboardingStatusLoaded(isCompleted: false));
    } catch (e) {
      emit(OnboardingError(
        message: 'Failed to reset onboarding: ${e.toString()}',
      ));
    }
  }
}