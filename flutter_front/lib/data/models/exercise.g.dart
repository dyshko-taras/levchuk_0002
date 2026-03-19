// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
  id: json['id'] as String,
  name: json['name'] as String,
  instruction: json['instruction'] as String,
  motivation: json['motivation'] as String,
  durationSeconds: (json['durationSeconds'] as num).toInt(),
  emoji: json['emoji'] as String,
);

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'instruction': instance.instruction,
  'motivation': instance.motivation,
  'durationSeconds': instance.durationSeconds,
  'emoji': instance.emoji,
};
