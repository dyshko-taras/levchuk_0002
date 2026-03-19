import 'package:json_annotation/json_annotation.dart';

part 'quote.g.dart';

@JsonSerializable()
class Quote {
  const Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.toneTag,
  });

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  final String id;
  final String text;
  final String author;
  final String toneTag;

  Map<String, dynamic> toJson() => _$QuoteToJson(this);
}
