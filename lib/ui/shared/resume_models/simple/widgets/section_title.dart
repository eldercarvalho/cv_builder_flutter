import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../constants.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({required this.text, required this.config});

  final String text;
  final TemplateConfig config;

  @override
  Widget build(Context context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: config.titleMediumTextStyle),
        SizedBox(height: 2),
        Container(height: 1, color: PdfColors.grey400),
      ],
    );
  }
}
