import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../models/social_network.dart';
import '../constants.dart';

class SocialNetworkInfo extends StatelessWidget {
  SocialNetworkInfo({
    required this.socialNetwork,
    required this.config,
  });

  final SocialNetwork socialNetwork;
  final TemplateConfig config;

  @override
  Widget build(Context context) {
    return _buildChild();
  }

  Widget _buildChild() {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          SvgImage(svg: getIconSvg(socialNetwork.name), colorFilter: PdfColors.black, width: 16),
          SizedBox(width: 8),
          Text(socialNetwork.name, style: config.bodySmallTextStyle),
          if (socialNetwork.username != null && socialNetwork.username!.isNotEmpty)
            Text(' - @${socialNetwork.username}', style: config.bodySmallTextStyle),
          if (socialNetwork.url != null && socialNetwork.url!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: UrlLink(
                child: SvgImage(svg: getIconSvg('link'), colorFilter: PdfColors.blue, width: 16),
                destination: socialNetwork.url!,
              ),
            ),
        ],
      ),
    );
  }
}
