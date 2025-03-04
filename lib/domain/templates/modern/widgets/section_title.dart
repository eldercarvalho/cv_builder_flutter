import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../constants.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({
    required this.text,
    required this.config,
    this.darkMode = false,
  });

  final String text;
  final TemplateConfig config;
  final bool darkMode;

  @override
  Widget build(Context context) {
    final style = darkMode ? config.titleMediumTextStyle.copyWith(color: PdfColors.white) : config.titleMediumTextStyle;
    // final color = darkMode ? const PdfColor.fromInt(0x40FFFFFF) : PdfColors.grey300;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: style),
          SizedBox(height: 2),
          Container(height: 1, color: PdfColors.grey400),
        ],
      ),
    );
  }
}
