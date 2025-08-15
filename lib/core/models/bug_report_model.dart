
class BugReportModel {
  final String title;
  final String description;
  final String stepsToReproduce;
  final String expectedBehavior;
  final String actualBehavior;
  final DeviceInfo deviceInfo;

  const BugReportModel({
    required this.title,
    required this.description,
    required this.stepsToReproduce,
    required this.expectedBehavior,
    required this.actualBehavior,
    required this.deviceInfo,
  });

  factory BugReportModel.fromJson(Map<String, dynamic> json) {
    return BugReportModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      stepsToReproduce: json['steps_to_reproduce'] ?? '',
      expectedBehavior: json['expected_behavior'] ?? '',
      actualBehavior: json['actual_behavior'] ?? '',
      deviceInfo: DeviceInfo.fromJson(json['device_info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'steps_to_reproduce': stepsToReproduce,
      'expected_behavior': expectedBehavior,
      'actual_behavior': actualBehavior,
      'device_info': deviceInfo.toJson(),
    };
  }

  
  Map<String, dynamic> toRequestJson() {
    return toJson(); 
  }

  BugReportModel copyWith({
    String? title,
    String? description,
    String? stepsToReproduce,
    String? expectedBehavior,
    String? actualBehavior,
    DeviceInfo? deviceInfo,
  }) {
    return BugReportModel(
      title: title ?? this.title,
      description: description ?? this.description,
      stepsToReproduce: stepsToReproduce ?? this.stepsToReproduce,
      expectedBehavior: expectedBehavior ?? this.expectedBehavior,
      actualBehavior: actualBehavior ?? this.actualBehavior,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }
}


class DeviceInfo {
  final String platform;
  final String osVersion;
  final String appVersion;
  final String deviceModel;
  final String? deviceId;
  final String? locale;
  final String? timezone;

  const DeviceInfo({
    required this.platform,
    required this.osVersion,
    required this.appVersion,
    required this.deviceModel,
    this.deviceId,
    this.locale,
    this.timezone,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      platform: json['platform'] ?? '',
      osVersion: json['os_version'] ?? '',
      appVersion: json['app_version'] ?? '',
      deviceModel: json['device_model'] ?? '',
      deviceId: json['device_id'],
      locale: json['locale'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'os_version': osVersion,
      'app_version': appVersion,
      'device_model': deviceModel,
      'device_id': deviceId,
      'locale': locale,
      'timezone': timezone,
    };
  }
}

