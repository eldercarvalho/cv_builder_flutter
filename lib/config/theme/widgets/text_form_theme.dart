import 'package:flutter/material.dart';

abstract class CvBuilderTextFormFieldTheme {

  static const lightTheme = InputDecorationTheme(
    fillColor: Color(0xFFf1f0f0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.black38),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.black87),
    ),
  );
}
