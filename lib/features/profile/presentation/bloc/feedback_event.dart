import 'package:equatable/equatable.dart';
import '../dto/suggestion_dto.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

class FeedbackSuggestionSubmitted extends FeedbackEvent {
  final SuggestionDto suggestion;

  const FeedbackSuggestionSubmitted({required this.suggestion});

  @override
  List<Object?> get props => [suggestion];
}

class FeedbackBugReportSubmitted extends FeedbackEvent {
  final String title;
  final String description;
  final String stepsToReproduce;
  final String expectedBehavior;
  final String actualBehavior;

  const FeedbackBugReportSubmitted({
    required this.title,
    required this.description,
    required this.stepsToReproduce,
    required this.expectedBehavior,
    required this.actualBehavior,
  });

  @override
  List<Object?> get props => [title, description, stepsToReproduce, expectedBehavior, actualBehavior];
}

class FeedbackConnectionTested extends FeedbackEvent {
  const FeedbackConnectionTested();
}

class FeedbackDeviceInfoRequested extends FeedbackEvent {
  const FeedbackDeviceInfoRequested();
}

class FeedbackStateReset extends FeedbackEvent {
  const FeedbackStateReset();
}