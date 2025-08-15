import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'bug_report_model.dart';

part 'suggestion_model.g.dart';

@JsonSerializable()
class SuggestionModel extends Equatable {
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

  factory SuggestionModel.fromJson(Map<String, dynamic> json) => _$SuggestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionModelToJson(this);

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

  @override
  List<Object?> get props => [
    title,
    description,
    useCase,
    deviceInfo,
  ];
}

