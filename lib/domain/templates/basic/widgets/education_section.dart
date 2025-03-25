import 'package:cv_builder/domain/templates/texts.dart';
import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../template_config.dart';
import 'section_title.dart';

List<Widget> buildEducation({required Resume resume, required TemplateConfig config}) {
  final ResumeSection sectionConfig = resume.sections.education;
  final resumeLanguage = resume.resumeLanguage!.name;
  final texts = getTexts(resume.resumeLanguage!);

  if (resume.education.isEmpty) {
    return [];
  }

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config),
      SizedBox(height: config.titleSpace),
    ],
    ...List.generate(resume.education.length, (index) {
      final education = resume.education[index];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(education.fieldOfStudy, style: config.leftTextTheme.titleXSmallTextStyle),
          SizedBox(height: config.lineSpace),
          Text(education.institution, style: config.leftTextTheme.bodyMediumTextStyle),
          SizedBox(height: config.lineSpace),
          Row(children: [
            Text(education.startDate.toShortDate(locale: resumeLanguage),
                style: config.leftTextTheme.bodyMediumTextStyle),
            if (education.endDate != null)
              Text('- ${education.endDate!.toShortDate(locale: resumeLanguage)}',
                  style: config.leftTextTheme.bodyMediumTextStyle),
            if (education.endDate == null) Text('- ${texts.current}', style: config.leftTextTheme.bodyMediumTextStyle),
          ]),
          if (education.summary != null) ...[
            SizedBox(height: config.lineSpace),
            Text(education.summary!, style: config.leftTextTheme.bodyMediumTextStyle),
          ],
          if (index < resume.education.length - 1) SizedBox(height: config.innerSpace),
        ],
      );
    }),
  ];
}
