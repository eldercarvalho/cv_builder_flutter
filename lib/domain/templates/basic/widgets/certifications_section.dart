import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../template_config.dart';
import 'section_title.dart';

List<Widget> buildCertifications({required Resume resume, required TemplateConfig config}) {
  final ResumeSection sectionConfig = resume.sections.certifications;

  if (resume.certifications.isEmpty) {
    return [SizedBox.shrink()];
  }

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config),
      SizedBox(height: config.titleSpace),
    ],
    ...List.generate(resume.certifications.length, (index) {
      final certification = resume.certifications[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(certification.title, style: config.leftTextTheme.titleXSmallTextStyle),
          Text(certification.issuer, style: config.leftTextTheme.bodyMediumTextStyle),
          if (certification.date != null)
            Text(certification.date!.toShortDate(locale: resume.resumeLanguage!.name),
                style: config.leftTextTheme.bodyMediumTextStyle),
          if (certification.summary != null) ...[
            SizedBox(height: config.lineSpace),
            Text(certification.summary!, style: config.leftTextTheme.paragraphTextStyle),
          ],
        ],
      );
    }),
  ];
}
