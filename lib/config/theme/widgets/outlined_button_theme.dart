import 'package:flutter/material.dart';

import '../colors.dart';

abstract class CvBuilderOutlinedButtonTheme {
  static final lightTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      // backgroundColor: CbColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      side: const BorderSide(
        color: CbColors.primary,
        width: 2,
      ),
    ),
  );
}
