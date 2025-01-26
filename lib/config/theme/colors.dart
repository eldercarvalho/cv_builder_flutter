import 'package:flutter/material.dart';

class CbColors {
  static const primary = Color(0xFF189AB4);
  static const secondary = Color(0xFF05445E);
  static const background = Color(0xFFFFFFFF);
  static const surfaceOnBackground = Color(0xFFF5F5F5);
  static const surfaceContainer = Color(0xFFE0E0E0);

  static const border = Color(0xFFCECECE);

  static const error = Color(0xFFD32F2F);
}

abstract class CbColorScheme {
  static const ColorScheme light = ColorScheme.light(
    primary: CbColors.primary,
    secondary: CbColors.secondary,
    surface: CbColors.background,
    surfaceBright: CbColors.surfaceOnBackground,
    outline: CbColors.border,
  );
}
