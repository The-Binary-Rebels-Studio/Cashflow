/// Model for bug report submission and response
class BugReportModel {
  final String? id;
  final String title;
  final String description;
  final String stepsToReproduce;
  final String expectedBehavior;
  final String actualBehavior;
  final BugSeverity severity;
  final BugCategory category;
  final String? userEmail;
  final String? userName;
  final DeviceInfo deviceInfo;
  final BugStatus? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? attachments;
  final Map<String, dynamic>? metadata;

  const BugReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.stepsToReproduce,
    required this.expectedBehavior,
    required this.actualBehavior,
    required this.severity,
    required this.category,
    this.userEmail,
    this.userName,
    required this.deviceInfo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.attachments,
    this.metadata,
  });

  factory BugReportModel.fromJson(Map<String, dynamic> json) {
    return BugReportModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      stepsToReproduce: json['steps_to_reproduce'] ?? '',
      expectedBehavior: json['expected_behavior'] ?? '',
      actualBehavior: json['actual_behavior'] ?? '',
      severity: BugSeverity.fromString(json['severity'] ?? ''),
      category: BugCategory.fromString(json['category'] ?? ''),
      userEmail: json['user_email'],
      userName: json['user_name'],
      deviceInfo: DeviceInfo.fromJson(json['device_info'] ?? {}),
      status: json['status'] != null 
          ? BugStatus.fromString(json['status']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      attachments: json['attachments'] != null 
          ? List<String>.from(json['attachments']) 
          : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'steps_to_reproduce': stepsToReproduce,
      'expected_behavior': expectedBehavior,
      'actual_behavior': actualBehavior,
      'severity': severity.value,
      'category': category.value,
      'user_email': userEmail,
      'user_name': userName,
      'device_info': deviceInfo.toJson(),
      'status': status?.value,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'attachments': attachments,
      'metadata': metadata,
    };
  }

  /// Create request payload for submission (excludes server-managed fields)
  Map<String, dynamic> toRequestJson() {
    return {
      'title': title,
      'description': description,
      'steps_to_reproduce': stepsToReproduce,
      'expected_behavior': expectedBehavior,
      'actual_behavior': actualBehavior,
      'severity': severity.value,
      'category': category.value,
      'user_email': userEmail,
      'user_name': userName,
      'device_info': deviceInfo.toJson(),
      'attachments': attachments,
      'metadata': metadata,
    };
  }

  BugReportModel copyWith({
    String? id,
    String? title,
    String? description,
    String? stepsToReproduce,
    String? expectedBehavior,
    String? actualBehavior,
    BugSeverity? severity,
    BugCategory? category,
    String? userEmail,
    String? userName,
    DeviceInfo? deviceInfo,
    BugStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
  }) {
    return BugReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      stepsToReproduce: stepsToReproduce ?? this.stepsToReproduce,
      expectedBehavior: expectedBehavior ?? this.expectedBehavior,
      actualBehavior: actualBehavior ?? this.actualBehavior,
      severity: severity ?? this.severity,
      category: category ?? this.category,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Device information for bug reports
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

/// Enum for bug severity levels
enum BugSeverity {
  low('low'),
  medium('medium'),
  high('high'),
  critical('critical');

  const BugSeverity(this.value);
  final String value;

  static BugSeverity fromString(String value) {
    return BugSeverity.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BugSeverity.medium,
    );
  }

  String get displayName {
    switch (this) {
      case BugSeverity.low:
        return 'Low';
      case BugSeverity.medium:
        return 'Medium';
      case BugSeverity.high:
        return 'High';
      case BugSeverity.critical:
        return 'Critical';
    }
  }
}

/// Enum for bug categories
enum BugCategory {
  crash('crash'),
  ui('ui'),
  functionality('functionality'),
  performance('performance'),
  data('data'),
  security('security'),
  other('other');

  const BugCategory(this.value);
  final String value;

  static BugCategory fromString(String value) {
    return BugCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BugCategory.other,
    );
  }

  String get displayName {
    switch (this) {
      case BugCategory.crash:
        return 'App Crash';
      case BugCategory.ui:
        return 'UI Issue';
      case BugCategory.functionality:
        return 'Functionality';
      case BugCategory.performance:
        return 'Performance';
      case BugCategory.data:
        return 'Data Issue';
      case BugCategory.security:
        return 'Security';
      case BugCategory.other:
        return 'Other';
    }
  }
}

/// Enum for bug status (server-managed)
enum BugStatus {
  reported('reported'),
  investigating('investigating'),
  confirmed('confirmed'),
  inProgress('in_progress'),
  testing('testing'),
  resolved('resolved'),
  closed('closed');

  const BugStatus(this.value);
  final String value;

  static BugStatus fromString(String value) {
    return BugStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BugStatus.reported,
    );
  }

  String get displayName {
    switch (this) {
      case BugStatus.reported:
        return 'Reported';
      case BugStatus.investigating:
        return 'Investigating';
      case BugStatus.confirmed:
        return 'Confirmed';
      case BugStatus.inProgress:
        return 'In Progress';
      case BugStatus.testing:
        return 'Testing';
      case BugStatus.resolved:
        return 'Resolved';
      case BugStatus.closed:
        return 'Closed';
    }
  }
}