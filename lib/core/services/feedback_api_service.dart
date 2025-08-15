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


  
  void dispose() {
    _dio.close();
  }
}