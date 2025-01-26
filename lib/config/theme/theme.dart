import 'package:flutter/material.dart';

import 'colors.dart';
import 'widgets/app_bar_theme.dart';
import 'widgets/filled_button_theme.dart';
import 'widgets/outlined_button_theme.dart';
import 'widgets/text_form_theme.dart';

class CvBuilderTheme {
  CvBuilderTheme._();

  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    colorScheme: CbColorScheme.light,
    appBarTheme: CvBuilderAppBarTheme.lightTheme,
    // scaffoldBackgroundColor: const Color(0xFFdedede),
    inputDecorationTheme: CvBuilderTextFormFieldTheme.lightTheme,
    filledButtonTheme: CvBuilderFilledButtonTheme.lightTheme,
    outlinedButtonTheme: CvBuilderOutlinedButtonTheme.lightTheme,
  );
}
