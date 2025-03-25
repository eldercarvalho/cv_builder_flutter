// Text Styles
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../models/resume.dart';

class TemplateConfig {
  TemplateConfig._({
    required this.titleLargeTextStyle1,
    required this.titleMediumTextStyle1,
    required this.titleSmallTextStyle1,
    required this.titleXSmallTextStyle1,
    required this.bodyLargeTextStyle1,
    required this.bodyMediumTextStyle1,
    required this.bodySmallTextStyle1,
    required this.paragraphTextStyle1,
    required this.titleLargeTextStyle2,
    required this.titleMediumTextStyle2,
    required this.titleSmallTextStyle2,
    required this.titleXSmallTextStyle2,
    required this.bodyLargeTextStyle2,
    required this.bodyMediumTextStyle2,
    required this.bodySmallTextStyle2,
    required this.paragraphTextStyle2,
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

  final TextStyle titleLargeTextStyle1;
  final TextStyle titleMediumTextStyle1;
  final TextStyle titleSmallTextStyle1;
  final TextStyle titleXSmallTextStyle1;

  final TextStyle bodyLargeTextStyle1;
  final TextStyle bodyMediumTextStyle1;
  final TextStyle bodySmallTextStyle1;
  final TextStyle paragraphTextStyle1;

  final TextStyle titleLargeTextStyle2;
  final TextStyle titleMediumTextStyle2;
  final TextStyle titleSmallTextStyle2;
  final TextStyle titleXSmallTextStyle2;

  final TextStyle bodyLargeTextStyle2;
  final TextStyle bodyMediumTextStyle2;
  final TextStyle bodySmallTextStyle2;
  final TextStyle paragraphTextStyle2;

  final ResumeTheme theme;

  static Future<TemplateConfig> getInstance(ResumeTheme theme) async {
    final fontBold = await PdfGoogleFonts.cabinBold();
    final fontRegular = await PdfGoogleFonts.cabinRegular();
    final primaryColors = theme.primaryColors;
    final secondaryColors = theme.secondaryColors;

    return TemplateConfig._(
      titleLargeTextStyle1: TextStyle(font: fontBold, fontSize: 20, color: PdfColor.fromHex(primaryColors.titleColor)),
      titleMediumTextStyle1: TextStyle(font: fontBold, fontSize: 16, color: PdfColor.fromHex(primaryColors.titleColor)),
      titleSmallTextStyle1: TextStyle(font: fontBold, fontSize: 14, color: PdfColor.fromHex(primaryColors.titleColor)),
      titleXSmallTextStyle1: TextStyle(font: fontBold, fontSize: 12, color: PdfColor.fromHex(primaryColors.titleColor)),
      bodyLargeTextStyle1: TextStyle(font: fontRegular, fontSize: 14, color: PdfColor.fromHex(primaryColors.textColor)),
      bodyMediumTextStyle1:
          TextStyle(font: fontRegular, fontSize: 12, color: PdfColor.fromHex(primaryColors.textColor)),
      bodySmallTextStyle1: TextStyle(font: fontRegular, fontSize: 10, color: PdfColor.fromHex(primaryColors.textColor)),
      paragraphTextStyle1:
          TextStyle(font: fontRegular, fontSize: 10, lineSpacing: 3, color: PdfColor.fromHex(primaryColors.textColor)),

      titleLargeTextStyle2:
          TextStyle(font: fontBold, fontSize: 20, color: PdfColor.fromHex(secondaryColors.titleColor)),
      titleMediumTextStyle2:
          TextStyle(font: fontBold, fontSize: 16, color: PdfColor.fromHex(secondaryColors.titleColor)),
      titleSmallTextStyle2:
          TextStyle(font: fontBold, fontSize: 14, color: PdfColor.fromHex(secondaryColors.titleColor)),
      titleXSmallTextStyle2:
          TextStyle(font: fontBold, fontSize: 12, color: PdfColor.fromHex(secondaryColors.titleColor)),
      bodyLargeTextStyle2:
          TextStyle(font: fontRegular, fontSize: 14, color: PdfColor.fromHex(secondaryColors.textColor)),
      bodyMediumTextStyle2:
          TextStyle(font: fontRegular, fontSize: 12, color: PdfColor.fromHex(secondaryColors.textColor)),
      bodySmallTextStyle2:
          TextStyle(font: fontRegular, fontSize: 10, color: PdfColor.fromHex(secondaryColors.textColor)),
      paragraphTextStyle2: TextStyle(
          font: fontRegular, fontSize: 10, lineSpacing: 3, color: PdfColor.fromHex(secondaryColors.textColor)),
      theme: theme,
      // iconTextStyle: TextStyle(font: faRegular400Font),
    );
  }
}
