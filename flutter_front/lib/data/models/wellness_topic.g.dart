// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WellnessTopic _$WellnessTopicFromJson(Map<String, dynamic> json) =>
    WellnessTopic(
      id: json['id'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String,
      shortDescription: json['shortDescription'] as String,
      tips: (json['tips'] as List<dynamic>)
          .map((e) => WellnessTip.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WellnessTopicToJson(WellnessTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'emoji': instance.emoji,
      'shortDescription': instance.shortDescription,
      'tips': instance.tips,
    };
