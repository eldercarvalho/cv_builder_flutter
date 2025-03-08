// Text Styles
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
    final interBold = await PdfGoogleFonts.interBold();
    final interRegular = await PdfGoogleFonts.interRegular();

    return TemplateConfig._(
      titleLargeTextStyle: TextStyle(font: interBold, fontSize: 20),
      titleMediumTextStyle: TextStyle(font: interBold, fontSize: 16),
      titleSmallTextStyle: TextStyle(font: interBold, fontSize: 14),
      titleXSmallTextStyle: TextStyle(font: interBold, fontSize: 12),
      bodyLargeTextStyle: TextStyle(font: interRegular, fontSize: 14),
      bodyMediumTextStyle: TextStyle(font: interRegular, fontSize: 12),
      bodySmallTextStyle: TextStyle(font: interRegular, fontSize: 10),
      paragraphTextStyle: TextStyle(font: interRegular, fontSize: 10, lineSpacing: 3),
      // iconTextStyle: TextStyle(font: faRegular400Font),
    );
  }
}

// // Page Config
const horizontalMargin = 60.0;
const verticalMargin = 36.0;
