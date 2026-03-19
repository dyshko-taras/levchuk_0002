import 'package:FlutterApp/data/models/exercise.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hourly_routine.g.dart';

@JsonSerializable()
class HourlyRoutine {
  const HourlyRoutine({
    required this.hour,
    required this.label,
    required this.sublabel,
    required this.exercise,
  });

  factory HourlyRoutine.fromJson(Map<String, dynamic> json) =>
      _$HourlyRoutineFromJson(json);

  final int hour;
  final String label;
  final String sublabel;
  final Exercise exercise;

  Map<String, dynamic> toJson() => _$HourlyRoutineToJson(this);
}
