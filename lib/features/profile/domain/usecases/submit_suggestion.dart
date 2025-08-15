import 'package:injectable/injectable.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/models/suggestion_model.dart';
import '../repositories/feedback_repository.dart';

/// Use case for submitting feature suggestions
/// Encapsulates the business logic for suggestion submission
@injectable
class SubmitSuggestion {
  final FeedbackRepository _repository;

  SubmitSuggestion(this._repository);

  /// Execute the suggestion submission use case
  /// 
  /// Takes a [SuggestionModel] and submits it through the repository
  /// Returns [ApiResponse<SuggestionModel>] with success/error status
  Future<ApiResponse<SuggestionModel>> call(SuggestionModel suggestion) async {
    // Additional business logic can be added here
    // For example: rate limiting, spam detection, etc.
    
    return await _repository.submitSuggestion(suggestion);
  }
}