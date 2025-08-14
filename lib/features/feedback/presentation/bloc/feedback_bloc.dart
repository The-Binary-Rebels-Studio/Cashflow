import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/submit_suggestion.dart';
import '../../domain/usecases/submit_bug_report.dart';
import '../../domain/usecases/get_device_info.dart';
import '../../domain/usecases/test_connection.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

/// BLoC for managing feedback feature state and business logic
/// Handles suggestion submissions, bug reports, and connection testing
@injectable
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final SubmitSuggestion _submitSuggestion;
  final SubmitBugReport _submitBugReport;
  final GetDeviceInfo _getDeviceInfo;
  final TestConnection _testConnection;

  FeedbackBloc(
    this._submitSuggestion,
    this._submitBugReport,
    this._getDeviceInfo,
    this._testConnection,
  ) : super(const FeedbackInitial()) {
    on<FeedbackSuggestionSubmitted>(_onSuggestionSubmitted);
    on<FeedbackBugReportSubmitted>(_onBugReportSubmitted);
    on<FeedbackConnectionTested>(_onConnectionTested);
    on<FeedbackDeviceInfoRequested>(_onDeviceInfoRequested);
    on<FeedbackStateReset>(_onStateReset);
  }

  /// Handle suggestion submission event
  Future<void> _onSuggestionSubmitted(
    FeedbackSuggestionSubmitted event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackLoading(message: 'Submitting suggestion...'));

    try {
      final result = await _submitSuggestion(event.suggestion);

      if (result.success && result.data != null) {
        emit(FeedbackSuggestionSuccess(
          suggestion: result.data!,
          message: result.message,
        ));
      } else {
        emit(FeedbackError(
          message: result.message,
          errorCode: result.error?.code,
          validationErrors: result.error?.validationErrors,
        ));
      }
    } catch (e) {
      emit(FeedbackError(
        message: 'An unexpected error occurred while submitting suggestion',
        errorCode: 'BLOC_ERROR',
      ));
    }
  }

  /// Handle bug report submission event
  Future<void> _onBugReportSubmitted(
    FeedbackBugReportSubmitted event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackLoading(message: 'Submitting bug report...'));

    try {
      final result = await _submitBugReport(event.bugReport);

      if (result.success && result.data != null) {
        emit(FeedbackBugReportSuccess(
          bugReport: result.data!,
          message: result.message,
        ));
      } else {
        emit(FeedbackError(
          message: result.message,
          errorCode: result.error?.code,
          validationErrors: result.error?.validationErrors,
        ));
      }
    } catch (e) {
      emit(FeedbackError(
        message: 'An unexpected error occurred while submitting bug report',
        errorCode: 'BLOC_ERROR',
      ));
    }
  }

  /// Handle connection test event
  Future<void> _onConnectionTested(
    FeedbackConnectionTested event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackLoading(message: 'Testing connection...'));

    try {
      final result = await _testConnection();

      if (result.success && result.data != null) {
        emit(FeedbackConnectionSuccess(
          connectionData: result.data!,
          message: result.message,
        ));
      } else {
        emit(FeedbackError(
          message: result.message,
          errorCode: result.error?.code,
        ));
      }
    } catch (e) {
      emit(FeedbackError(
        message: 'Connection test failed',
        errorCode: 'CONNECTION_ERROR',
      ));
    }
  }

  /// Handle device info request event
  Future<void> _onDeviceInfoRequested(
    FeedbackDeviceInfoRequested event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackLoading(message: 'Getting device info...'));

    try {
      final deviceInfo = await _getDeviceInfo();
      emit(FeedbackDeviceInfoSuccess(deviceInfo: deviceInfo));
    } catch (e) {
      emit(FeedbackError(
        message: 'Failed to get device information',
        errorCode: 'DEVICE_INFO_ERROR',
      ));
    }
  }

  /// Handle state reset event
  void _onStateReset(
    FeedbackStateReset event,
    Emitter<FeedbackState> emit,
  ) {
    emit(const FeedbackInitial());
  }
}