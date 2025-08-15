// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestionModel _$SuggestionModelFromJson(Map<String, dynamic> json) =>
    SuggestionModel(
      title: json['title'] as String,
      description: json['description'] as String,
      useCase: json['useCase'] as String,
      deviceInfo: DeviceInfo.fromJson(
        json['deviceInfo'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SuggestionModelToJson(SuggestionModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'useCase': instance.useCase,
      'deviceInfo': instance.deviceInfo,
    };
