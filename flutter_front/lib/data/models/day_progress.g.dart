// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayProgress _$DayProgressFromJson(Map<String, dynamic> json) => DayProgress(
  completedHours: (json['completedHours'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  breathingMinutes: (json['breathingMinutes'] as num).toInt(),
  workoutSessions: (json['workoutSessions'] as num).toInt(),
);

Map<String, dynamic> _$DayProgressToJson(DayProgress instance) =>
    <String, dynamic>{
      'completedHours': instance.completedHours,
      'breathingMinutes': instance.breathingMinutes,
      'workoutSessions': instance.workoutSessions,
    };
