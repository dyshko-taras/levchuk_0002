import 'package:json_annotation/json_annotation.dart';

part 'wellness_tip.g.dart';

@JsonSerializable()
class WellnessTip {
  const WellnessTip({
    required this.id,
    required this.title,
    required this.body,
  });

  factory WellnessTip.fromJson(Map<String, dynamic> json) =>
      _$WellnessTipFromJson(json);

  final String id;
  final String title;
  final String body;

  Map<String, dynamic> toJson() => _$WellnessTipToJson(this);
}
