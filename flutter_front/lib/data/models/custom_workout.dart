import 'package:json_annotation/json_annotation.dart';

import 'workout_step.dart';

part 'custom_workout.g.dart';

@JsonSerializable()
class CustomWorkout {
  const CustomWorkout({
    required this.id,
    required this.name,
    required this.steps,
    required this.createdAt,
  });

  factory CustomWorkout.fromJson(Map<String, dynamic> json) =>
      _$CustomWorkoutFromJson(json);

  final String id;
  final String name;
  final List<WorkoutStep> steps;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$CustomWorkoutToJson(this);
}
