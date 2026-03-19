// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourly_routine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HourlyRoutine _$HourlyRoutineFromJson(Map<String, dynamic> json) =>
    HourlyRoutine(
      hour: (json['hour'] as num).toInt(),
      label: json['label'] as String,
      sublabel: json['sublabel'] as String,
      exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HourlyRoutineToJson(HourlyRoutine instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'label': instance.label,
      'sublabel': instance.sublabel,
      'exercise': instance.exercise,
    };
