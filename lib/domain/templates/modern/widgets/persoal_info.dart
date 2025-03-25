import 'package:cv_builder/domain/models/models.dart';
import 'package:cv_builder/domain/models/resume.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../constants.dart';
import '../../icons.dart';
import '../../template_config.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({
    required this.text,
    required this.icon,
    required this.config,
    this.marginTop = 4,
    this.iconSize = 12,
    required this.column,
  });

  final String? text;
  final String icon;
  final double marginTop;
  final double iconSize;
  final TemplateConfig config;
  final TemplateColumn column;

  @override
  Widget build(Context context) {
    final textTheme = switch (column) {
      TemplateColumn.one => config.leftTextTheme,
      TemplateColumn.two => config.rightTextTheme,
    };

    final colors = switch (column) {
      TemplateColumn.one => config.theme.primaryColors,
      TemplateColumn.two => config.theme.secondaryColors,
    };

    if (text == null || (text != null && text!.isEmpty)) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: marginTop),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgImage(svg: getIconSvg(icon), colorFilter: PdfColor.fromHex(colors.iconColor), width: iconSize),
          SizedBox(width: 8),
          Expanded(child: Text(text!, style: textTheme.bodySmallTextStyle)),
        ],
      ),
    );
  }
}
