import 'package:equatable/equatable.dart';
import '../../../../core/models/suggestion_model.dart';
import '../../../../core/models/bug_report_model.dart';

/// Base class for all feedback events
abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

/// Event to submit a feature suggestion
class FeedbackSuggestionSubmitted extends FeedbackEvent {
  final SuggestionModel suggestion;

  const FeedbackSuggestionSubmitted({required this.suggestion});

  @override
  List<Object?> get props => [suggestion];
}

/// Event to submit a bug report
class FeedbackBugReportSubmitted extends FeedbackEvent {
  final BugReportModel bugReport;

  const FeedbackBugReportSubmitted({required this.bugReport});

  @override
  List<Object?> get props => [bugReport];
}

/// Event to test backend connectivity
class FeedbackConnectionTested extends FeedbackEvent {
  const FeedbackConnectionTested();
}

/// Event to get device information
class FeedbackDeviceInfoRequested extends FeedbackEvent {
  const FeedbackDeviceInfoRequested();
}

/// Event to reset feedback state
class FeedbackStateReset extends FeedbackEvent {
  const FeedbackStateReset();
}