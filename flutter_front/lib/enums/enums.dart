import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum BreathingMode {
  calm('calm'),
  energy('energy'),
  focus('focus');

  const BreathingMode(this.value);

  final String value;
}
