// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomWorkout _$CustomWorkoutFromJson(Map<String, dynamic> json) =>
    CustomWorkout(
      id: json['id'] as String,
      name: json['name'] as String,
      steps: (json['steps'] as List<dynamic>)
          .map((e) => WorkoutStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CustomWorkoutToJson(CustomWorkout instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'steps': instance.steps,
      'createdAt': instance.createdAt.toIso8601String(),
    };
