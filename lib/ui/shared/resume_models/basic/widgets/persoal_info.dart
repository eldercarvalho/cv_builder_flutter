import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../constants.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({
    required this.text,
    required this.icon,
    this.iconColor = PdfColors.black,
    required this.config,
    this.marginTop = 6,
    this.iconSize = 16,
  });

  final String? text;
  final String icon;
  final double marginTop;
  double iconSize;
  final TemplateConfig config;
  PdfColor iconColor;

  @override
  Widget build(Context context) {
    if (text == null || (text != null && text!.isEmpty)) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: marginTop),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgImage(svg: getIconSvg(icon), colorFilter: PdfColors.black, width: iconSize),
          SizedBox(width: 8),
          Expanded(child: Text(text!, style: config.bodyMediumTextStyle)),
        ],
      ),
    );
  }
}
