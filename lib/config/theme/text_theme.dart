import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CbBuilderLightTextTheme {
  static TextTheme get _nunitoSansTextTheme => GoogleFonts.nunitoSansTextTheme(const TextTheme());

  static TextTheme get nunitoSans => _nunitoSansTextTheme.copyWith(
        headlineSmall: GoogleFonts.nunitoSans(
          fontSize: 32.sp,
          fontWeight: FontWeight.w800,
        ),
        titleLarge: GoogleFonts.nunitoSans(
          fontSize: 20.sp,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: GoogleFonts.nunitoSans(
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
        ),
        titleSmall: GoogleFonts.nunitoSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: GoogleFonts.nunitoSans(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.nunitoSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        //caption2
        displayLarge: GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
        labelLarge: GoogleFonts.nunitoSans(
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
        ),
        labelMedium: GoogleFonts.nunitoSans(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.nunitoSans(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
        ),
      );
}
