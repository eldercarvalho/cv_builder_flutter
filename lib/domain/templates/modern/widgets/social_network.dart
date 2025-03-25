import 'package:cv_builder/domain/models/resume.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../models/social_network.dart';
import '../../constants.dart';
import '../../icons.dart';
import '../../template_config.dart';

class SocialNetworkInfo extends StatelessWidget {
  SocialNetworkInfo({
    required this.socialNetwork,
    required this.config,
    required this.column,
  });

  final SocialNetwork socialNetwork;
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

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          SvgImage(
            svg: getIconSvg(socialNetwork.name),
            colorFilter: PdfColor.fromHex(colors.iconColor),
            width: 12,
          ),
          SizedBox(width: 8),
          // Text(socialNetwork.name, style: config.bodySmallTextStyle2),
          if (socialNetwork.username != null && socialNetwork.username!.isNotEmpty)
            Text('@${socialNetwork.username}', style: textTheme.bodySmallTextStyle),
          if (socialNetwork.url != null && socialNetwork.url!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: UrlLink(
                child: SvgImage(
                  svg: getIconSvg('link'),
                  colorFilter: PdfColor.fromHex(colors.linkColor),
                  width: 12,
                ),
                destination: socialNetwork.url!,
              ),
            ),
        ],
      ),
    );
  }
}
