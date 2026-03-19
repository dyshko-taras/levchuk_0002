// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
  dailyProgress: (json['dailyProgress'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, DayProgress.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{'dailyProgress': instance.dailyProgress};
