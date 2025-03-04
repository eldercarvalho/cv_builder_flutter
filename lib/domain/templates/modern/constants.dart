// Text Styles
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

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

  static Future<TemplateConfig> get instance async {
    final fontBold = await PdfGoogleFonts.cabinBold();
    final fontRegular = await PdfGoogleFonts.cabinRegular();

    return TemplateConfig._(
      titleLargeTextStyle: TextStyle(font: fontBold, fontSize: 20),
      titleMediumTextStyle: TextStyle(font: fontBold, fontSize: 16),
      titleSmallTextStyle: TextStyle(font: fontBold, fontSize: 14),
      titleXSmallTextStyle: TextStyle(font: fontBold, fontSize: 12),
      bodyLargeTextStyle: TextStyle(font: fontRegular, fontSize: 14, color: PdfColors.grey700),
      bodyMediumTextStyle: TextStyle(font: fontRegular, fontSize: 12, color: PdfColors.grey700),
      bodySmallTextStyle: TextStyle(font: fontRegular, fontSize: 10, color: PdfColors.grey700),
      paragraphTextStyle: TextStyle(font: fontRegular, fontSize: 10, lineSpacing: 3, color: PdfColors.grey700),
      // iconTextStyle: TextStyle(font: faRegular400Font),
    );
  }
}

// // Page Config
const horizontalMargin = 60.0;
const verticalMargin = 40.0;
