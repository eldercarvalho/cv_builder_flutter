import 'package:cv_builder/domain/models/resume.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../constants.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({required this.text, required this.config});

  final String text;
  final TemplateConfig config;

  @override
  Widget build(Context context) {
    final colors = config.theme.primaryColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: config.titleSmallTextStyle),
        SizedBox(height: 2),
        Container(height: 1, color: PdfColor.fromHex(colors.dividerColor)),
      ],
    );
  }
}
