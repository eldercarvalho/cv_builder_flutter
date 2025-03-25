import 'package:cv_builder/domain/templates/texts.dart';
import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../constants.dart';
import '../../template_config.dart';
import 'box.dart';
import 'section_title.dart';

List<Widget> buildEducation({
  required Resume resume,
  required TemplateConfig config,
  required TemplateColumn column,
}) {
  final ResumeSection sectionConfig = resume.sections.education;
  final resumeLanguage = resume.resumeLanguage!.name;
  final texts = getTexts(resume.resumeLanguage!);

  final textTheme = switch (column) {
    TemplateColumn.one => config.leftTextTheme,
    TemplateColumn.two => config.rightTextTheme,
  };

  // final colors = switch (column) {
  //   TemplateColumn.one => config.theme.primaryColors,
  //   TemplateColumn.two => config.theme.secondaryColors,
  // };

  if (resume.education.isEmpty) {
    return [];
  }

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config, column: column),
      SizedBox(height: config.titleSpace),
    ],
    ...List.generate(
      resume.education.length,
      (index) {
        final education = resume.education[index];
        return Box(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(education.fieldOfStudy, style: textTheme.titleSmallTextStyle),
              SizedBox(height: config.lineSpace),
              Text(education.institution, style: textTheme.bodyMediumTextStyle),
              SizedBox(height: config.lineSpace),
              Row(children: [
                Text(education.startDate.toShortDate(locale: resumeLanguage), style: textTheme.bodyMediumTextStyle),
                if (education.endDate != null)
                  Text('- ${education.endDate!.toShortDate(locale: resumeLanguage)}',
                      style: textTheme.bodyMediumTextStyle),
                if (education.endDate == null) Text('- ${texts.current}', style: textTheme.bodyMediumTextStyle),
              ]),
              if (education.summary != null) ...[
                SizedBox(height: config.lineSpace),
                Text(education.summary!, style: textTheme.bodyMediumTextStyle),
              ],
              if (index < resume.education.length - 1) SizedBox(height: config.innerSpace),
            ],
          ),
        );
      },
    ),
  ];
}
