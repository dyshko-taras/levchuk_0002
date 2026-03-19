import 'package:json_annotation/json_annotation.dart';

import 'day_progress.dart';

part 'user_progress.g.dart';

@JsonSerializable()
class UserProgress {
  const UserProgress({
    required this.dailyProgress,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);

  final Map<String, DayProgress> dailyProgress;

  Map<String, dynamic> toJson() => _$UserProgressToJson(this);

  factory UserProgress.empty() => const UserProgress(dailyProgress: {});
}
