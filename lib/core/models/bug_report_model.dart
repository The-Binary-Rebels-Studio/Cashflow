
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bug_report_model.g.dart';

@JsonSerializable()
class BugReportModel extends Equatable {
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

  factory BugReportModel.fromJson(Map<String, dynamic> json) => _$BugReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$BugReportModelToJson(this);

  
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

  @override
  List<Object?> get props => [
    title,
    description,
    stepsToReproduce,
    expectedBehavior,
    actualBehavior,
    deviceInfo,
  ];
}


@JsonSerializable()
class DeviceInfo extends Equatable {
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

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);

  @override
  List<Object?> get props => [
    platform,
    osVersion,
    appVersion,
    deviceModel,
    deviceId,
    locale,
    timezone,
  ];
}

