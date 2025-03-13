import 'package:cv_builder/domain/models/models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../constants.dart';
import '../constants.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({
    required this.text,
    required this.config,
    required this.column,
  });

  final String text;
  final TemplateConfig config;
  final TemplateColumn column;

  @override
  Widget build(Context context) {
    final style = switch (column) {
      TemplateColumn.one => config.titleMediumTextStyle1,
      TemplateColumn.two => config.titleMediumTextStyle2,
    };

    final colors = switch (column) {
      TemplateColumn.one => config.theme.primaryColors,
      TemplateColumn.two => config.theme.secondaryColors,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: style),
          SizedBox(height: 2),
          Container(height: 1, color: PdfColor.fromHex(colors.dividerColor)),
        ],
      ),
    );
  }
}
