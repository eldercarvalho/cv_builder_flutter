import 'package:flutter/material.dart';

abstract class CvBuilderFilledButtonTheme {
  static final lightTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: const Color(0xFF0F52BA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
