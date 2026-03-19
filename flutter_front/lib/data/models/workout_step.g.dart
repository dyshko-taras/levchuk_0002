// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutStep _$WorkoutStepFromJson(Map<String, dynamic> json) => WorkoutStep(
  id: json['id'] as String,
  name: json['name'] as String,
  durationSeconds: (json['durationSeconds'] as num).toInt(),
  isCustom: json['isCustom'] as bool,
);

Map<String, dynamic> _$WorkoutStepToJson(WorkoutStep instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'durationSeconds': instance.durationSeconds,
      'isCustom': instance.isCustom,
    };
