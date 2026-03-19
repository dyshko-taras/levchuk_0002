import 'package:json_annotation/json_annotation.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.instruction,
    required this.motivation,
    required this.durationSeconds,
    required this.emoji,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  final String id;
  final String name;
  final String instruction;
  final String motivation;
  final int durationSeconds;
  final String emoji;

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}
