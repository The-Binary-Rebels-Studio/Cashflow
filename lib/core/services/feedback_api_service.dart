import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/api_response.dart';
import '../models/suggestion_model.dart';
import '../models/bug_report_model.dart';

@singleton
class FeedbackApiService {
  static const String _baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://54.169.145.202/api/v1/');
  static const Duration _timeout = Duration(seconds: 30);
  
  late final Dio _dio;
  late final DeviceInfoPlugin _deviceInfo;
  
  FeedbackApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
      sendTimeout: _timeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'CashFlow-Mobile/1.0.0',
      },
    ));
    
    _deviceInfo = DeviceInfoPlugin();
    
  }

  /// Submit a feature suggestion to the backend
  /// 
  /// Request Example:
  /// POST /suggestions
  /// {
  ///   "title": "Add Dark Mode Support",
  ///   "description": "Please add dark mode to improve user experience in low light conditions",
  ///   "use_case": "Users need dark mode for better experience during night time usage",
  ///   "device_info": {
  ///     "platform": "android",
  ///     "os_version": "Android 13",
  ///     "app_version": "1.0.0",
  ///     "device_model": "Samsung Galaxy S23",
  ///     "locale": "en_US",
  ///     "timezone": "Asia/Jakarta"
  ///   }
  /// }
  /// 
  /// Expected Response:
  /// {
  ///   "success": true,
  ///   "message": "Suggestion submitted successfully",
  ///   "data": {
  ///     "title": "Add Dark Mode Support",
  ///     "description": "Please add dark mode to improve user experience in low light conditions",
  ///     "use_case": "Users need dark mode for better experience during night time usage",
  ///     "device_info": {
  ///       "platform": "android",
  ///       "os_version": "Android 13",
  ///       "app_version": "1.0.0",
  ///       "device_model": "Samsung Galaxy S23",
  ///       "locale": "en_US",
  ///       "timezone": "Asia/Jakarta"
  ///     }
  ///   },
  ///   "meta": {
  ///     "timestamp": "2025-01-15T10:30:00Z",
  ///     "version": "v1"
  ///   }
  /// }
  Future<ApiResponse<SuggestionModel>> submitSuggestion(
    SuggestionModel suggestion,
  ) async {
    try {
      final response = await _dio.post(
        '/suggestions',
        data: suggestion.toRequestJson(),
      );

      final responseData = response.data;
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<SuggestionModel>.fromJson(
          responseData,
          (json) => SuggestionModel.fromJson(json as Map<String, dynamic>),
        );
      } else {
        return ApiResponse<SuggestionModel>(
          success: false,
          message: responseData['message'] ?? 'Failed to submit suggestion',
          error: responseData['error'] != null 
              ? ApiError.fromJson(responseData['error'])
              : null,
        );
      }
    } catch (e) {
      
      return ApiResponse<SuggestionModel>(
        success: false,
        message: 'Network error occurred while submitting suggestion',
        error: ApiError(
          code: 'NETWORK_ERROR',
          message: e.toString(),
        ),
      );
    }
  }

  /// Submit a bug report to the backend
  /// 
  /// Request Example:
  /// POST /bug-reports
  /// {
  ///   "title": "App crashes when adding transaction",
  ///   "description": "The app crashes consistently when trying to add a new transaction with amount over 1000",
  ///   "steps_to_reproduce": "1. Open app\n2. Click Add Transaction\n3. Enter amount > 1000\n4. Click Save",
  ///   "expected_behavior": "Transaction should be saved successfully",
  ///   "actual_behavior": "App crashes and closes",
  ///   "severity": "high",
  ///   "category": "crash",
  ///   "user_email": "user@example.com",
  ///   "user_name": "Jane Doe",
  ///   "device_info": {
  ///     "platform": "android",
  ///     "os_version": "Android 13",
  ///     "app_version": "1.0.0",
  ///     "device_model": "Samsung Galaxy S23",
  ///     "locale": "en_US",
  ///     "timezone": "Asia/Jakarta"
  ///   },
  ///   "attachments": [],
  ///   "metadata": {
  ///     "crash_stack_trace": "...",
  ///     "memory_usage": "256MB"
  ///   }
  /// }
  /// 
  /// Expected Response:
  /// {
  ///   "success": true,
  ///   "message": "Bug report submitted successfully",
  ///   "data": {
  ///     "id": "bug_123456789",
  ///     "title": "App crashes when adding transaction",
  ///     "description": "The app crashes consistently when trying to add a new transaction with amount over 1000",
  ///     "steps_to_reproduce": "1. Open app\n2. Click Add Transaction\n3. Enter amount > 1000\n4. Click Save",
  ///     "expected_behavior": "Transaction should be saved successfully",
  ///     "actual_behavior": "App crashes and closes",
  ///     "severity": "high",
  ///     "category": "crash",
  ///     "user_email": "user@example.com",
  ///     "user_name": "Jane Doe",
  ///     "device_info": {
  ///       "platform": "android",
  ///       "os_version": "Android 13",
  ///       "app_version": "1.0.0",
  ///       "device_model": "Samsung Galaxy S23",
  ///       "locale": "en_US",
  ///       "timezone": "Asia/Jakarta"
  ///     },
  ///     "status": "reported",
  ///     "created_at": "2025-01-15T10:30:00Z",
  ///     "updated_at": "2025-01-15T10:30:00Z",
  ///     "attachments": [],
  ///     "metadata": {
  ///       "crash_stack_trace": "...",
  ///       "memory_usage": "256MB"
  ///     }
  ///   },
  ///   "meta": {
  ///     "timestamp": "2025-01-15T10:30:00Z",
  ///     "version": "v1"
  ///   }
  /// }
  Future<ApiResponse<BugReportModel>> submitBugReport(
    BugReportModel bugReport,
  ) async {
    try {
      final response = await _dio.post(
        '/bug-reports',
        data: bugReport.toRequestJson(),
      );

      final responseData = response.data;
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<BugReportModel>.fromJson(
          responseData,
          (json) => BugReportModel.fromJson(json as Map<String, dynamic>),
        );
      } else {
        return ApiResponse<BugReportModel>(
          success: false,
          message: responseData['message'] ?? 'Failed to submit bug report',
          error: responseData['error'] != null 
              ? ApiError.fromJson(responseData['error'])
              : null,
        );
      }
    } catch (e) {
      return ApiResponse<BugReportModel>(
        success: false,
        message: 'Network error occurred while submitting bug report',
        error: ApiError(
          code: 'NETWORK_ERROR',
          message: e.toString(),
        ),
      );
    }
  }

  /// Get current device information
  Future<DeviceInfo> getCurrentDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;
      return DeviceInfo(
        platform: 'android',
        osVersion: 'Android ${androidInfo.version.release}',
        appVersion: packageInfo.version,
        deviceModel: '${androidInfo.brand} ${androidInfo.model}',
        deviceId: androidInfo.id,
        locale: Platform.localeName,
        timezone: DateTime.now().timeZoneName,
      );
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfo.iosInfo;
      return DeviceInfo(
        platform: 'ios',
        osVersion: '${iosInfo.systemName} ${iosInfo.systemVersion}',
        appVersion: packageInfo.version,
        deviceModel: iosInfo.model,
        deviceId: iosInfo.identifierForVendor,
        locale: Platform.localeName,
        timezone: DateTime.now().timeZoneName,
      );
    } else {
      return DeviceInfo(
        platform: Platform.operatingSystem,
        osVersion: Platform.operatingSystemVersion,
        appVersion: packageInfo.version,
        deviceModel: 'Unknown',
        locale: Platform.localeName,
        timezone: DateTime.now().timeZoneName,
      );
    }
  }

  /// Test backend connectivity
  /// 
  /// Request Example:
  /// GET /health
  /// 
  /// Expected Response:
  /// {
  ///   "success": true,
  ///   "message": "Service is healthy",
  ///   "data": {
  ///     "status": "ok",
  ///     "timestamp": "2025-01-15T10:30:00Z",
  ///     "version": "v1"
  ///   },
  ///   "meta": {
  ///     "timestamp": "2025-01-15T10:30:00Z",
  ///     "version": "v1"
  ///   }
  /// }
  Future<ApiResponse<Map<String, dynamic>>> testConnection() async {
    try {
      final response = await _dio.get('/health');

      final responseData = response.data;
      
      if (response.statusCode == 200) {
        return ApiResponse<Map<String, dynamic>>.fromJson(
          responseData,
          (json) => json as Map<String, dynamic>,
        );
      } else {
        return ApiResponse<Map<String, dynamic>>(
          success: false,
          message: responseData['message'] ?? 'Health check failed',
        );
      }
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        message: 'Unable to connect to server',
        error: ApiError(
          code: 'CONNECTION_ERROR',
          message: e.toString(),
        ),
      );
    }
  }


  /// Dispose resources
  void dispose() {
    _dio.close();
  }
}