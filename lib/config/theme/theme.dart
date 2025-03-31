import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_theme.dart';
import 'widgets/app_bar_theme.dart';
import 'widgets/filled_button_theme.dart';
import 'widgets/outlined_button_theme.dart';
import 'widgets/text_form_theme.dart';

class CvBuilderTheme {
  CvBuilderTheme._();

  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito Sans',
    brightness: Brightness.light,
    colorScheme: CbColorScheme.light,
    textTheme: CbBuilderLightTextTheme.textTheme,
    appBarTheme: CvBuilderAppBarTheme.lightTheme,
    // scaffoldBackgroundColor: const Color(0xFFdedede),
    inputDecorationTheme: CvBuilderTextFormFieldTheme.lightTheme,
    filledButtonTheme: CvBuilderFilledButtonTheme.lightTheme,
    outlinedButtonTheme: CvBuilderOutlinedButtonTheme.lightTheme,
    // dividerColor: CbColors.border,
    dividerTheme: const DividerThemeData(space: 0, thickness: 1, color: CbColors.border),
  );
}
