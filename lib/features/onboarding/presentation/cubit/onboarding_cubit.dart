import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';

import 'package:cashflow/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:cashflow/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:cashflow/features/onboarding/domain/usecases/reset_onboarding.dart';
import 'package:cashflow/features/onboarding/domain/entities/onboarding_settings.dart';
import 'package:cashflow/features/localization/domain/usecases/change_locale.dart';
import 'package:cashflow/core/services/currency_service.dart';
import 'package:cashflow/features/onboarding/presentation/cubit/onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final GetOnboardingStatus _getOnboardingStatus;
  final CompleteOnboarding _completeOnboarding;
  final ResetOnboarding _resetOnboarding;
  final ChangeLocale _changeLocale;

  OnboardingCubit(
    this._getOnboardingStatus,
    this._completeOnboarding,
    this._resetOnboarding,
    this._changeLocale,
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

  Future<void> saveOnboardingSettings(OnboardingSettings settings) async {
    try {
      emit(OnboardingLoading());
      
      // Save currency
      final currencyService = GetIt.instance<CurrencyService>();
      await currencyService.setSelectedCurrency(settings.selectedCurrency);
      
      // Save locale
      await _changeLocale(settings.selectedLocale.locale);
      
      // Complete onboarding
      await _completeOnboarding();
      
      emit(OnboardingCompleted());
    } catch (e) {
      emit(OnboardingError(
        message: 'Failed to save onboarding settings: ${e.toString()}',
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