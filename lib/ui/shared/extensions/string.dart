import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  Color toColor() {
    final hexCode = replaceAll('#', '');

    if (hexCode.length == 6) {
      return Color(int.parse('0xFF$hexCode'));
    } else if (hexCode.length == 8) {
      return Color(int.parse('0x$hexCode'));
    }

    return Colors.black;
  }
}
