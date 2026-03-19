import 'package:flutter/widgets.dart';

abstract final class AppRadius {
  static const sm = BorderRadius.all(Radius.circular(10));
  static const md = BorderRadius.all(Radius.circular(15));
  static const lg = BorderRadius.all(Radius.circular(20));
  static const xl = BorderRadius.all(Radius.circular(25));
  static const pill = BorderRadius.all(Radius.circular(999));
}
