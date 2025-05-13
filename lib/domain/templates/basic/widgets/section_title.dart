import 'package:cv_builder/domain/models/resume.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../template_config.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({required this.text, required this.config, this.hideDivider = false});

  final String text;
  final TemplateConfig config;
  final bool hideDivider;

  @override
  Widget build(Context context) {
    final colors = config.theme.primaryColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: config.leftTextTheme.titleSmallTextStyle),
        SizedBox(height: 2),
        if (!hideDivider) Container(height: 1, color: PdfColor.fromHex(colors.dividerColor)),
      ],
    );
  }
}
