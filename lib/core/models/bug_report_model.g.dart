// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bug_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BugReportModel _$BugReportModelFromJson(Map<String, dynamic> json) =>
    BugReportModel(
      title: json['title'] as String,
      description: json['description'] as String,
      stepsToReproduce: json['stepsToReproduce'] as String,
      expectedBehavior: json['expectedBehavior'] as String,
      actualBehavior: json['actualBehavior'] as String,
      deviceInfo: DeviceInfo.fromJson(
        json['deviceInfo'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$BugReportModelToJson(BugReportModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'stepsToReproduce': instance.stepsToReproduce,
      'expectedBehavior': instance.expectedBehavior,
      'actualBehavior': instance.actualBehavior,
      'deviceInfo': instance.deviceInfo,
    };

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
  platform: json['platform'] as String,
  osVersion: json['osVersion'] as String,
  appVersion: json['appVersion'] as String,
  deviceModel: json['deviceModel'] as String,
  deviceId: json['deviceId'] as String?,
  locale: json['locale'] as String?,
  timezone: json['timezone'] as String?,
);

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'osVersion': instance.osVersion,
      'appVersion': instance.appVersion,
      'deviceModel': instance.deviceModel,
      'deviceId': instance.deviceId,
      'locale': instance.locale,
      'timezone': instance.timezone,
    };
