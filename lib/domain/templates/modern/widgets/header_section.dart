import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../template_config.dart';
import 'box.dart';

class HeaderSection extends StatelessWidget {
  HeaderSection({this.photo, required this.resume, required this.config});

  final ImageProvider? photo;
  final Resume resume;
  final TemplateConfig config;

  @override
  Widget build(Context context) {
    return Box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(resume.name, style: config.rightTextTheme.titleLargeTextStyle),
          if (resume.profession != null) Text(resume.profession!, style: config.rightTextTheme.bodyLargeTextStyle),
          // SizedBox(height: config.sectionSpace),
        ],
      ),
    );
  }
}
