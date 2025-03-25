import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../constants.dart';
import '../../template_config.dart';
import 'box.dart';
import 'section_title.dart';

List<Widget> buildCertifications({
  required Resume resume,
  required TemplateConfig config,
  required TemplateColumn column,
}) {
  final ResumeSection sectionConfig = resume.sections.certifications;

  final textTheme = switch (column) {
    TemplateColumn.one => config.leftTextTheme,
    TemplateColumn.two => config.rightTextTheme,
  };

  // final colors = switch (column) {
  //   TemplateColumn.one => config.theme.primaryColors,
  //   TemplateColumn.two => config.theme.secondaryColors,
  // };

  if (resume.certifications.isEmpty) {
    return [];
  }

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config, column: column),
      SizedBox(height: config.titleSpace),
    ],
    ...List.generate(
      resume.certifications.length,
      (index) {
        final certification = resume.certifications[index];
        return Box(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(certification.title, style: textTheme.titleSmallTextStyle),
              Text(certification.issuer, style: textTheme.bodyMediumTextStyle),
              if (certification.date != null)
                Text(certification.date!.toShortDate(locale: resume.resumeLanguage!.name),
                    style: textTheme.bodyMediumTextStyle),
              if (certification.summary != null) ...[
                SizedBox(height: config.lineSpace),
                Text(certification.summary!, style: textTheme.paragraphTextStyle),
              ],
              if (index < resume.certifications.length - 1) SizedBox(height: config.innerSpace),
            ],
          ),
        );
      },
    ),
  ];
}
