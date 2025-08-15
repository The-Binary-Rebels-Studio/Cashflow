import 'package:equatable/equatable.dart';
import '../../../../core/models/bug_report_model.dart';


abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object?> get props => [];
}


class FeedbackInitial extends FeedbackState {
  const FeedbackInitial();
}


class FeedbackLoading extends FeedbackState {
  final String? message;

  const FeedbackLoading({this.message});

  @override
  List<Object?> get props => [message];
}


class FeedbackSuggestionSuccess extends FeedbackState {
  final String message;

  const FeedbackSuggestionSuccess({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}


class FeedbackBugReportSuccess extends FeedbackState {
  final String message;

  const FeedbackBugReportSuccess({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}


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


class FeedbackDeviceInfoSuccess extends FeedbackState {
  final DeviceInfo deviceInfo;

  const FeedbackDeviceInfoSuccess({required this.deviceInfo});

  @override
  List<Object?> get props => [deviceInfo];
}


class FeedbackError extends FeedbackState {
  final String message;
  final String? errorCode;

  const FeedbackError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];

  bool get isNetworkError => 
      errorCode == 'NETWORK_ERROR' || 
      errorCode == 'CONNECTION_ERROR' ||
      message.toLowerCase().contains('network') ||
      message.toLowerCase().contains('connection');

  
  String get userMessage {
    if (isNetworkError) {
      return 'Please check your internet connection and try again.';
    } else {
      return message;
    }
  }
}