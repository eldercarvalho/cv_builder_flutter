import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../template_config.dart';

class HeaderSection extends StatelessWidget {
  HeaderSection({this.photo, required this.resume, required this.config});

  final ImageProvider? photo;
  final Resume resume;
  final TemplateConfig config;

  @override
  Widget build(Context context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.,
      children: [
        if (photo != null) ...[
          Container(
            width: config.imageSize,
            height: config.imageSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: photo!, fit: BoxFit.cover),
            ),
          ),
          SizedBox(width: 24),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(resume.name, style: config.leftTextTheme.titleLargeTextStyle),
              if (resume.profession != null) Text(resume.profession!, style: config.leftTextTheme.bodyLargeTextStyle),
            ],
          ),
        ),
      ],
    );
  }
}
