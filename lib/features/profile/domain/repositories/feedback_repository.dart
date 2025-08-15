import '../../../../core/models/api_response.dart';
import '../../../../core/models/suggestion_model.dart';
import '../../../../core/models/bug_report_model.dart';


abstract class FeedbackRepository {
  
  
  Future<ApiResponse<SuggestionModel>> submitSuggestion(SuggestionModel suggestion);
  
  
  
  Future<ApiResponse<BugReportModel>> submitBugReport(BugReportModel bugReport);
  
  
  
  Future<ApiResponse<Map<String, dynamic>>> testConnection();
  
  
  
  Future<DeviceInfo> getCurrentDeviceInfo();
}