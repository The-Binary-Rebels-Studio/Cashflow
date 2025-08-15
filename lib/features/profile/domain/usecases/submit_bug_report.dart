import 'package:injectable/injectable.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/models/bug_report_model.dart';
import '../repositories/feedback_repository.dart';

/// Use case for submitting bug reports
/// Encapsulates the business logic for bug report submission
@injectable
class SubmitBugReport {
  final FeedbackRepository _repository;

  SubmitBugReport(this._repository);

  /// Execute the bug report submission use case
  /// 
  /// Takes a [BugReportModel] and submits it through the repository
  /// Returns [ApiResponse<BugReportModel>] with success/error status
  Future<ApiResponse<BugReportModel>> call(BugReportModel bugReport) async {
    // Additional business logic can be added here
    // For example: duplicate detection, automatic categorization, etc.
    
    return await _repository.submitBugReport(bugReport);
  }
}