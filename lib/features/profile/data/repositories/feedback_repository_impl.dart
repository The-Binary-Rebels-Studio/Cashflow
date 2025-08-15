import 'package:injectable/injectable.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/models/suggestion_model.dart';
import '../../../../core/models/bug_report_model.dart';
import '../../domain/repositories/feedback_repository.dart';
import '../datasources/feedback_remote_datasource.dart';

/// Implementation of FeedbackRepository
/// Handles business logic and delegates data operations to datasources
@LazySingleton(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource _remoteDataSource;

  FeedbackRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResponse<SuggestionModel>> submitSuggestion(
    SuggestionModel suggestion,
  ) async {
    try {
      // Validate suggestion data before submission
      if (suggestion.title.trim().isEmpty) {
        return ApiResponse<SuggestionModel>(
          success: false,
          message: 'Suggestion title cannot be empty',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Title is required',
          ),
        );
      }

      if (suggestion.description.trim().isEmpty) {
        return ApiResponse<SuggestionModel>(
          success: false,
          message: 'Suggestion description cannot be empty',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Description is required',
          ),
        );
      }

      if (suggestion.title.trim().length < 10) {
        return ApiResponse<SuggestionModel>(
          success: false,
          message: 'Suggestion title must be at least 10 characters long',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Title too short',
          ),
        );
      }

      if (suggestion.description.trim().length < 20) {
        return ApiResponse<SuggestionModel>(
          success: false,
          message: 'Suggestion description must be at least 20 characters long',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Description too short',
          ),
        );
      }

      if (suggestion.useCase.trim().isEmpty) {
        return ApiResponse<SuggestionModel>(
          success: false,
          message: 'Use case cannot be empty',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Use case is required',
          ),
        );
      }

      if (suggestion.useCase.trim().length < 10) {
        return ApiResponse<SuggestionModel>(
          success: false,
          message: 'Use case must be at least 10 characters long',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Use case too short',
          ),
        );
      }

      return await _remoteDataSource.submitSuggestion(suggestion);
    } catch (e) {
      return ApiResponse<SuggestionModel>(
        success: false,
        message: 'Repository error: ${e.toString()}',
        error: ApiError(
          code: 'REPOSITORY_ERROR',
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
      // Validate bug report data before submission
      if (bugReport.title.trim().isEmpty) {
        return ApiResponse<BugReportModel>(
          success: false,
          message: 'Bug title cannot be empty',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Title is required',
          ),
        );
      }

      if (bugReport.description.trim().isEmpty) {
        return ApiResponse<BugReportModel>(
          success: false,
          message: 'Bug description cannot be empty',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Description is required',
          ),
        );
      }

      if (bugReport.stepsToReproduce.trim().isEmpty) {
        return ApiResponse<BugReportModel>(
          success: false,
          message: 'Steps to reproduce cannot be empty',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Steps to reproduce are required',
          ),
        );
      }

      if (bugReport.expectedBehavior.trim().isEmpty) {
        return ApiResponse<BugReportModel>(
          success: false,
          message: 'Expected behavior cannot be empty',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Expected behavior is required',
          ),
        );
      }

      if (bugReport.actualBehavior.trim().isEmpty) {
        return ApiResponse<BugReportModel>(
          success: false,
          message: 'Actual behavior cannot be empty',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Actual behavior is required',
          ),
        );
      }

      if (bugReport.title.trim().length < 10) {
        return ApiResponse<BugReportModel>(
          success: false,
          message: 'Bug title must be at least 10 characters long',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Title too short',
          ),
        );
      }

      if (bugReport.description.trim().length < 20) {
        return ApiResponse<BugReportModel>(
          success: false,
          message: 'Bug description must be at least 20 characters long',
          error: ApiError(
            code: 'VALIDATION_ERROR',
            message: 'Description too short',
          ),
        );
      }

      // Email validation removed since userEmail field no longer exists

      return await _remoteDataSource.submitBugReport(bugReport);
    } catch (e) {
      return ApiResponse<BugReportModel>(
        success: false,
        message: 'Repository error: ${e.toString()}',
        error: ApiError(
          code: 'REPOSITORY_ERROR',
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> testConnection() async {
    try {
      return await _remoteDataSource.testConnection();
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Connection test failed: ${e.toString()}',
        error: ApiError(
          code: 'REPOSITORY_ERROR',
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<DeviceInfo> getCurrentDeviceInfo() async {
    try {
      return await _remoteDataSource.getCurrentDeviceInfo();
    } catch (e) {
      // Return fallback device info if unable to get actual info
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