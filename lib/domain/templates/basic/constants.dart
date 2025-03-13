// Text Styles
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../models/resume.dart';

class TemplateConfig {
  TemplateConfig._({
    required this.titleLargeTextStyle,
    required this.titleMediumTextStyle,
    required this.titleSmallTextStyle,
    required this.titleXSmallTextStyle,
    required this.bodyLargeTextStyle,
    required this.bodyMediumTextStyle,
    required this.bodySmallTextStyle,
    required this.paragraphTextStyle,
    required this.theme,
    // required this.iconTextStyle,
  });

  final horizontalMargin = 50.0;
  final verticalMargin = 40.0;

// Image
  final imageSize = 50.0;

// Spacing
  final sectionSpace = 18.0;
  final titleSpace = 12.0;
  final innerSpace = 12.0;
  final lineSpace = 3.0;

  final TextStyle titleLargeTextStyle;
  final TextStyle titleMediumTextStyle;
  final TextStyle titleSmallTextStyle;
  final TextStyle titleXSmallTextStyle;

  final TextStyle bodyLargeTextStyle;
  final TextStyle bodyMediumTextStyle;
  final TextStyle bodySmallTextStyle;
  final TextStyle paragraphTextStyle;
  // final TextStyle iconTextStyle;

  final ResumeTheme theme;

  static Future<TemplateConfig> getInstance(ResumeTheme theme) async {
    final interBold = await PdfGoogleFonts.interBold();
    final interRegular = await PdfGoogleFonts.interRegular();
    final colors = theme.primaryColors;

    return TemplateConfig._(
      theme: theme,
      titleLargeTextStyle: TextStyle(font: interBold, fontSize: 20, color: PdfColor.fromHex(colors.titleColor)),
      titleMediumTextStyle: TextStyle(font: interBold, fontSize: 16, color: PdfColor.fromHex(colors.titleColor)),
      titleSmallTextStyle: TextStyle(font: interBold, fontSize: 14, color: PdfColor.fromHex(colors.titleColor)),
      titleXSmallTextStyle: TextStyle(font: interBold, fontSize: 12, color: PdfColor.fromHex(colors.titleColor)),
      bodyLargeTextStyle: TextStyle(font: interRegular, fontSize: 14, color: PdfColor.fromHex(colors.textColor)),
      bodyMediumTextStyle: TextStyle(font: interRegular, fontSize: 12, color: PdfColor.fromHex(colors.textColor)),
      bodySmallTextStyle: TextStyle(font: interRegular, fontSize: 10, color: PdfColor.fromHex(colors.textColor)),
      paragraphTextStyle:
          TextStyle(font: interRegular, fontSize: 10, lineSpacing: 3, color: PdfColor.fromHex(colors.textColor)),
    );
  }
}

// // Page Config
const horizontalMargin = 40.0;
const verticalMargin = 40.0;
