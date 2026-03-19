// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) => Quote(
  id: json['id'] as String,
  text: json['text'] as String,
  author: json['author'] as String,
  toneTag: json['toneTag'] as String,
);

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'author': instance.author,
  'toneTag': instance.toneTag,
};
