import 'package:json_annotation/json_annotation.dart';

part 'workout_step.g.dart';

@JsonSerializable()
class WorkoutStep {
  const WorkoutStep({
    required this.id,
    required this.name,
    required this.durationSeconds,
    required this.isCustom,
  });

  factory WorkoutStep.fromJson(Map<String, dynamic> json) =>
      _$WorkoutStepFromJson(json);

  final String id;
  final String name;
  final int durationSeconds;
  final bool isCustom;

  Map<String, dynamic> toJson() => _$WorkoutStepToJson(this);
}
