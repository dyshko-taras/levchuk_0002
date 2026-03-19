import 'package:json_annotation/json_annotation.dart';

part 'day_progress.g.dart';

@JsonSerializable()
class DayProgress {
  const DayProgress({
    required this.completedHours,
    required this.breathingMinutes,
    required this.workoutSessions,
  });

  factory DayProgress.fromJson(Map<String, dynamic> json) =>
      _$DayProgressFromJson(json);

  final List<int> completedHours;
  final int breathingMinutes;
  final int workoutSessions;

  Map<String, dynamic> toJson() => _$DayProgressToJson(this);
}
