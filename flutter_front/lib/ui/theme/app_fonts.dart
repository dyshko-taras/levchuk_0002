import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const bodyFamily = 'Open Sans';
  static const displayFamily = 'Rubik';

  static TextStyle display({
    double size = 26,
    FontWeight weight = FontWeight.w700,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: displayFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.15,
    );
  }

  static TextStyle body({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: bodyFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.4,
    );
  }
}
