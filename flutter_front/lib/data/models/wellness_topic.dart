import 'package:json_annotation/json_annotation.dart';

import 'wellness_tip.dart';

part 'wellness_topic.g.dart';

@JsonSerializable()
class WellnessTopic {
  const WellnessTopic({
    required this.id,
    required this.title,
    required this.emoji,
    required this.shortDescription,
    required this.tips,
  });

  factory WellnessTopic.fromJson(Map<String, dynamic> json) =>
      _$WellnessTopicFromJson(json);

  final String id;
  final String title;
  final String emoji;
  final String shortDescription;
  final List<WellnessTip> tips;

  Map<String, dynamic> toJson() => _$WellnessTopicToJson(this);
}
