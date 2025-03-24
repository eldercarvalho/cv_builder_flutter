// Text Styles
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../models/resume.dart';

class TemplateConfig {
  TemplateConfig._({
    required this.horizontalMargin,
    required this.verticalMargin,
    required this.imageSize,
    required this.theme,
    required this.leftTextTheme,
    required this.rightTextTheme,
  });

  final double horizontalMargin;
  final double verticalMargin;

// Image
  final double imageSize;

// Spacing
  final double sectionSpace = 18.0;
  final double titleSpace = 12.0;
  final double innerSpace = 12.0;
  final double lineSpace = 3.0;

  final ResumeTheme theme;
  final TemplateTextTheme leftTextTheme;
  final TemplateTextTheme rightTextTheme;

  static Future<TemplateConfig> getInstance({
    required ResumeTheme theme,
    TemplateFont font = TemplateFont.inter,
    double horizontalMargin = 50.0,
    double verticalMargin = 40.0,
    double imageSize = 50.0,
  }) async {
    final fonts = await getTemplateFonts(font);
    final leftColors = theme.primaryColors;
    final rightColors = theme.secondaryColors;

    return TemplateConfig._(
      theme: theme,
      horizontalMargin: horizontalMargin,
      verticalMargin: verticalMargin,
      imageSize: imageSize,
      leftTextTheme: TemplateTextTheme(
        titleLargeTextStyle: TextStyle(font: fonts.bold, fontSize: 20, color: leftColors.titleColor.toColor()),
        titleMediumTextStyle: TextStyle(font: fonts.bold, fontSize: 16, color: leftColors.titleColor.toColor()),
        titleSmallTextStyle: TextStyle(font: fonts.bold, fontSize: 14, color: leftColors.titleColor.toColor()),
        titleXSmallTextStyle: TextStyle(font: fonts.bold, fontSize: 12, color: leftColors.titleColor.toColor()),
        bodyLargeTextStyle: TextStyle(font: fonts.regular, fontSize: 14, color: leftColors.textColor.toColor()),
        bodyMediumTextStyle: TextStyle(font: fonts.regular, fontSize: 12, color: leftColors.textColor.toColor()),
        bodySmallTextStyle: TextStyle(font: fonts.regular, fontSize: 10, color: leftColors.textColor.toColor()),
        paragraphTextStyle:
            TextStyle(font: fonts.regular, fontSize: 10, lineSpacing: 3, color: leftColors.textColor.toColor()),
      ),
      rightTextTheme: TemplateTextTheme(
        titleLargeTextStyle: TextStyle(font: fonts.bold, fontSize: 20, color: rightColors.titleColor.toColor()),
        titleMediumTextStyle: TextStyle(font: fonts.bold, fontSize: 16, color: rightColors.titleColor.toColor()),
        titleSmallTextStyle: TextStyle(font: fonts.bold, fontSize: 14, color: rightColors.titleColor.toColor()),
        titleXSmallTextStyle: TextStyle(font: fonts.bold, fontSize: 12, color: rightColors.titleColor.toColor()),
        bodyLargeTextStyle: TextStyle(font: fonts.regular, fontSize: 14, color: rightColors.textColor.toColor()),
        bodyMediumTextStyle: TextStyle(font: fonts.regular, fontSize: 12, color: rightColors.textColor.toColor()),
        bodySmallTextStyle: TextStyle(font: fonts.regular, fontSize: 10, color: rightColors.textColor.toColor()),
        paragraphTextStyle:
            TextStyle(font: fonts.regular, fontSize: 10, lineSpacing: 3, color: rightColors.textColor.toColor()),
      ),
    );
  }
}

extension StringX on String {
  PdfColor toColor() {
    return PdfColor.fromHex(this);
  }
}

class TemplateTextTheme {
  final TextStyle titleLargeTextStyle;
  final TextStyle titleMediumTextStyle;
  final TextStyle titleSmallTextStyle;
  final TextStyle titleXSmallTextStyle;
  final TextStyle bodyLargeTextStyle;
  final TextStyle bodyMediumTextStyle;
  final TextStyle bodySmallTextStyle;
  final TextStyle paragraphTextStyle;

  TemplateTextTheme({
    required this.titleLargeTextStyle,
    required this.titleMediumTextStyle,
    required this.titleSmallTextStyle,
    required this.titleXSmallTextStyle,
    required this.bodyLargeTextStyle,
    required this.bodyMediumTextStyle,
    required this.bodySmallTextStyle,
    required this.paragraphTextStyle,
  });
}

enum TemplateFont {
  inter,
  cabin,
}

class TemplateFonts {
  final Font bold;
  final Font regular;

  TemplateFonts({
    required this.bold,
    required this.regular,
  });
}

Future<TemplateFonts> getTemplateFonts(TemplateFont font) async {
  switch (font) {
    case TemplateFont.inter:
      return TemplateFonts(
        bold: await PdfGoogleFonts.interBold(),
        regular: await PdfGoogleFonts.interRegular(),
      );
    case TemplateFont.cabin:
      return TemplateFonts(
        bold: await PdfGoogleFonts.cabinBold(),
        regular: await PdfGoogleFonts.cabinRegular(),
      );
  }
}
