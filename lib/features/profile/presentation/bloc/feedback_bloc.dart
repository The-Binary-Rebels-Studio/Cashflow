import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/models/suggestion_model.dart';
import '../../../../core/models/bug_report_model.dart';
import '../../domain/usecases/submit_suggestion.dart';
import '../../domain/usecases/submit_bug_report.dart';
import '../../domain/usecases/get_device_info.dart';
import '../../domain/usecases/test_connection.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

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

  Future<void> _onSuggestionSubmitted(
    FeedbackSuggestionSubmitted event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackLoading(message: 'Submitting suggestion...'));

    try {
      final deviceInfo = await _getDeviceInfo();
      
      final suggestionModel = SuggestionModel(
        title: event.suggestion.title,
        description: event.suggestion.description,
        useCase: event.suggestion.useCase,
        deviceInfo: deviceInfo,
      );

      final result = await _submitSuggestion(suggestionModel);

      if (result.success) {
        emit(const FeedbackSuggestionSuccess(message: 'Suggestion submitted successfully'));
      } else {
        emit(FeedbackError(
          message: result.message,
          errorCode: result.error?.code,
        ));
      }
    } catch (e) {
      emit(const FeedbackError(
        message: 'An unexpected error occurred',
        errorCode: 'BLOC_ERROR',
      ));
    }
  }

  Future<void> _onBugReportSubmitted(
    FeedbackBugReportSubmitted event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(const FeedbackLoading(message: 'Submitting bug report...'));

    try {
      final deviceInfo = await _getDeviceInfo();
      
      final bugReportModel = BugReportModel(
        title: event.title,
        description: event.description,
        stepsToReproduce: event.stepsToReproduce,
        expectedBehavior: event.expectedBehavior,
        actualBehavior: event.actualBehavior,
        deviceInfo: deviceInfo,
      );

      final result = await _submitBugReport(bugReportModel);

      if (result.success) {
        emit(const FeedbackBugReportSuccess(message: 'Bug report submitted successfully'));
      } else {
        emit(FeedbackError(
          message: result.message,
          errorCode: result.error?.code,
        ));
      }
    } catch (e) {
      emit(const FeedbackError(
        message: 'An unexpected error occurred',
        errorCode: 'BLOC_ERROR',
      ));
    }
  }

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

  void _onStateReset(
    FeedbackStateReset event,
    Emitter<FeedbackState> emit,
  ) {
    emit(const FeedbackInitial());
  }
}