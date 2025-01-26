import 'package:flutter/material.dart';

import '../colors.dart';

abstract class CvBuilderFilledButtonTheme {
  static final lightTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: CbColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
