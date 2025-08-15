import '../../../../core/models/api_response.dart';
import '../../../../core/models/suggestion_model.dart';
import '../../../../core/models/bug_report_model.dart';

/// Repository interface for feedback operations
/// Defines the contract for feedback-related data operations
abstract class FeedbackRepository {
  /// Submit a feature suggestion
  /// Returns success response with suggestion data or error response
  Future<ApiResponse<SuggestionModel>> submitSuggestion(SuggestionModel suggestion);
  
  /// Submit a bug report
  /// Returns success response with bug report data or error response
  Future<ApiResponse<BugReportModel>> submitBugReport(BugReportModel bugReport);
  
  /// Test backend connectivity
  /// Returns success response if backend is reachable
  Future<ApiResponse<Map<String, dynamic>>> testConnection();
  
  /// Get current device information
  /// Returns device info for bug reports and suggestions
  Future<DeviceInfo> getCurrentDeviceInfo();
}