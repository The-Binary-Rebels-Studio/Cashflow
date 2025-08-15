import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';

import 'package:cashflow/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:cashflow/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:cashflow/features/onboarding/domain/usecases/reset_onboarding.dart';
import 'package:cashflow/features/localization/domain/usecases/change_locale.dart';
import 'package:cashflow/core/services/currency_bloc.dart';
import 'package:cashflow/core/services/currency_event.dart';
import 'package:cashflow/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:cashflow/features/onboarding/presentation/bloc/onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingStatus _getOnboardingStatus;
  final CompleteOnboarding _completeOnboarding;
  final ResetOnboarding _resetOnboarding;
  final ChangeLocale _changeLocale;

  OnboardingBloc(
    this._getOnboardingStatus,
    this._completeOnboarding,
    this._resetOnboarding,
    this._changeLocale,
  ) : super(OnboardingInitial()) {
    on<OnboardingStatusChecked>(_onStatusChecked);
    on<OnboardingCompletionRequested>(_onCompletionRequested);
    on<OnboardingSettingsSaved>(_onSettingsSaved);
    on<OnboardingReset>(_onReset);
  }

  Future<void> _onStatusChecked(
    OnboardingStatusChecked event,
    Emitter<OnboardingState> emit,
  ) async {
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

  Future<void> _onCompletionRequested(
    OnboardingCompletionRequested event,
    Emitter<OnboardingState> emit,
  ) async {
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

  Future<void> _onSettingsSaved(
    OnboardingSettingsSaved event,
    Emitter<OnboardingState> emit,
  ) async {
    try {
      emit(OnboardingLoading());
      
      
      final currencyBloc = GetIt.instance<CurrencyBloc>();
      currencyBloc.add(CurrencySelected(currency: event.settings.selectedCurrency));
      
      
      await _changeLocale(event.settings.selectedLocale.locale);
      
      
      await _completeOnboarding();
      
      emit(OnboardingCompleted());
    } catch (e) {
      emit(OnboardingError(
        message: 'Failed to save onboarding settings: ${e.toString()}',
      ));
    }
  }

  Future<void> _onReset(
    OnboardingReset event,
    Emitter<OnboardingState> emit,
  ) async {
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