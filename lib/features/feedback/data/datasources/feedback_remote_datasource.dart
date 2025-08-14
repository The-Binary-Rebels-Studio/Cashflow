import 'package:injectable/injectable.dart';
import '../../../../core/services/feedback_api_service.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/models/suggestion_model.dart';
import '../../../../core/models/bug_report_model.dart';

/// Remote data source for feedback operations
/// Handles communication with the backend API
abstract class FeedbackRemoteDataSource {
  /// Submit a feature suggestion to the backend
  Future<ApiResponse<SuggestionModel>> submitSuggestion(SuggestionModel suggestion);
  
  /// Submit a bug report to the backend
  Future<ApiResponse<BugReportModel>> submitBugReport(BugReportModel bugReport);
  
  /// Test backend connectivity
  Future<ApiResponse<Map<String, dynamic>>> testConnection();
  
  /// Get current device information
  Future<DeviceInfo> getCurrentDeviceInfo();
}

@LazySingleton(as: FeedbackRemoteDataSource)
class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final FeedbackApiService _apiService;

  FeedbackRemoteDataSourceImpl(this._apiService);

  @override
  Future<ApiResponse<SuggestionModel>> submitSuggestion(
    SuggestionModel suggestion,
  ) async {
    try {
      return await _apiService.submitSuggestion(suggestion);
    } catch (e) {
      return ApiResponse<SuggestionModel>(
        success: false,
        message: 'Failed to submit suggestion: ${e.toString()}',
        error: ApiError(
          code: 'DATASOURCE_ERROR',
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResponse<BugReportModel>> submitBugReport(
    BugReportModel bugReport,
  ) async {
    try {
      return await _apiService.submitBugReport(bugReport);
    } catch (e) {
      return ApiResponse<BugReportModel>(
        success: false,
        message: 'Failed to submit bug report: ${e.toString()}',
        error: ApiError(
          code: 'DATASOURCE_ERROR',
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> testConnection() async {
    try {
      return await _apiService.testConnection();
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Connection test failed: ${e.toString()}',
        error: ApiError(
          code: 'CONNECTION_ERROR',
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DeviceInfo> getCurrentDeviceInfo() async {
    try {
      return await _apiService.getCurrentDeviceInfo();
    } catch (e) {
      // Return a fallback device info if unable to get actual info
      return const DeviceInfo(
        platform: 'unknown',
        osVersion: 'unknown',
        appVersion: '1.0.0',
        deviceModel: 'unknown',
        locale: 'en_US',
        timezone: 'UTC',
      );
    }
  }
}