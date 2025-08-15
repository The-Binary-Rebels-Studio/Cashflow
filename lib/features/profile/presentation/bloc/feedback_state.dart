import 'package:equatable/equatable.dart';
import '../../../../core/models/suggestion_model.dart';
import '../../../../core/models/bug_report_model.dart';
import '../../../../core/models/api_response.dart';

/// Base class for all feedback states
abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the feedback feature
class FeedbackInitial extends FeedbackState {
  const FeedbackInitial();
}

/// State when a feedback operation is in progress
class FeedbackLoading extends FeedbackState {
  final String? message;

  const FeedbackLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when suggestion submission is successful
class FeedbackSuggestionSuccess extends FeedbackState {
  final SuggestionModel suggestion;
  final String message;

  const FeedbackSuggestionSuccess({
    required this.suggestion,
    required this.message,
  });

  @override
  List<Object?> get props => [suggestion, message];
}

/// State when bug report submission is successful
class FeedbackBugReportSuccess extends FeedbackState {
  final BugReportModel bugReport;
  final String message;

  const FeedbackBugReportSuccess({
    required this.bugReport,
    required this.message,
  });

  @override
  List<Object?> get props => [bugReport, message];
}

/// State when connection test is successful
class FeedbackConnectionSuccess extends FeedbackState {
  final Map<String, dynamic> connectionData;
  final String message;

  const FeedbackConnectionSuccess({
    required this.connectionData,
    required this.message,
  });

  @override
  List<Object?> get props => [connectionData, message];
}

/// State when device info is retrieved successfully
class FeedbackDeviceInfoSuccess extends FeedbackState {
  final DeviceInfo deviceInfo;

  const FeedbackDeviceInfoSuccess({required this.deviceInfo});

  @override
  List<Object?> get props => [deviceInfo];
}

/// State when a feedback operation fails
class FeedbackError extends FeedbackState {
  final String message;
  final String? errorCode;
  final List<ValidationError>? validationErrors;

  const FeedbackError({
    required this.message,
    this.errorCode,
    this.validationErrors,
  });

  @override
  List<Object?> get props => [message, errorCode, validationErrors];

  /// Check if this is a validation error
  bool get isValidationError => validationErrors != null && validationErrors!.isNotEmpty;

  /// Check if this is a network error
  bool get isNetworkError => 
      errorCode == 'NETWORK_ERROR' || 
      errorCode == 'CONNECTION_ERROR' ||
      message.toLowerCase().contains('network') ||
      message.toLowerCase().contains('connection');

  /// Get user-friendly error message
  String get userMessage {
    if (isValidationError) {
      return 'Please check your input and try again.';
    } else if (isNetworkError) {
      return 'Please check your internet connection and try again.';
    } else {
      return message;
    }
  }
}