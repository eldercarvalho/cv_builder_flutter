import 'package:flutter/material.dart';

import 'widgets/app_bar_theme.dart';
import 'widgets/filled_button_theme.dart';
import 'widgets/text_form_theme.dart';

class CvBuilderTheme {
  CvBuilderTheme._();

  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    primaryColor: const Color(0xFF0F52BA),
    appBarTheme: CvBuilderAppBarTheme.lightTheme,
    // scaffoldBackgroundColor: const Color(0xFFdedede),
    inputDecorationTheme: CvBuilderTextFormFieldTheme.lightTheme,
    filledButtonTheme: CvBuilderFilledButtonTheme.lightTheme,
  );
}
