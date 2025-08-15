import 'package:injectable/injectable.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/models/bug_report_model.dart';
import '../repositories/feedback_repository.dart';


@injectable
class SubmitBugReport {
  final FeedbackRepository _repository;

  SubmitBugReport(this._repository);

  
  
  
  
  Future<ApiResponse<BugReportModel>> call(BugReportModel bugReport) async {
    
    
    
    return await _repository.submitBugReport(bugReport);
  }
}