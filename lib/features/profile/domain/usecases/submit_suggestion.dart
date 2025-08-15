import 'package:injectable/injectable.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/models/suggestion_model.dart';
import '../repositories/feedback_repository.dart';


@injectable
class SubmitSuggestion {
  final FeedbackRepository _repository;

  SubmitSuggestion(this._repository);

  
  
  
  
  Future<ApiResponse<SuggestionModel>> call(SuggestionModel suggestion) async {
    
    
    
    return await _repository.submitSuggestion(suggestion);
  }
}