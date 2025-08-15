import 'bug_report_model.dart';


class SuggestionModel {
  final String title;
  final String description;
  final String useCase;
  final DeviceInfo deviceInfo;

  const SuggestionModel({
    required this.title,
    required this.description,
    required this.useCase,
    required this.deviceInfo,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      useCase: json['use_case'] ?? '',
      deviceInfo: DeviceInfo.fromJson(json['device_info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'use_case': useCase,
      'device_info': deviceInfo.toJson(),
    };
  }

  Map<String, dynamic> toRequestJson() {
    return toJson();
  }

  SuggestionModel copyWith({
    String? title,
    String? description,
    String? useCase,
    DeviceInfo? deviceInfo,
  }) {
    return SuggestionModel(
      title: title ?? this.title,
      description: description ?? this.description,
      useCase: useCase ?? this.useCase,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }
}

