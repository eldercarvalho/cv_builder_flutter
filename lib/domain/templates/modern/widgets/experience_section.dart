import 'package:cv_builder/domain/templates/texts.dart';
import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../constants.dart';
import '../../icons.dart';
import '../../template_config.dart';
import 'box.dart';
import 'section_title.dart';

List<Widget> buildExperience({
  required Resume resume,
  required TemplateConfig config,
  required TemplateColumn column,
}) {
  final ResumeSection sectionConfig = resume.sections.experience;
  final resumeLanguage = resume.resumeLanguage!.name;
  final texts = getTexts(resume.resumeLanguage!);

  final textTheme = switch (column) {
    TemplateColumn.one => config.leftTextTheme,
    TemplateColumn.two => config.rightTextTheme,
  };

  final colors = switch (column) {
    TemplateColumn.one => config.theme.primaryColors,
    TemplateColumn.two => config.theme.secondaryColors,
  };

  if (resume.workExperience.isEmpty) {
    return [];
  }

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config, column: column),
      SizedBox(height: config.titleSpace),
    ],
    ...List.generate(
      resume.workExperience.length,
      (index) {
        final experience = resume.workExperience[index];
        return Box(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(experience.position, style: textTheme.titleSmallTextStyle),
              SizedBox(height: config.lineSpace),
              Row(
                children: [
                  Text(experience.company, style: textTheme.bodyMediumTextStyle),
                  if (experience.website.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: UrlLink(
                        child: SvgImage(
                          svg: getIconSvg('link'),
                          colorFilter: PdfColor.fromHex(colors.linkColor),
                          width: 12,
                        ),
                        destination: experience.website,
                      ),
                    ),
                ],
              ),
              SizedBox(height: config.lineSpace),
              Row(children: [
                Text(experience.startDate.toShortDate(locale: resumeLanguage), style: textTheme.bodyMediumTextStyle),
                if (experience.endDate != null)
                  Text(' - ${experience.endDate!.toShortDate(locale: resumeLanguage)}',
                      style: textTheme.bodyMediumTextStyle),
                if (experience.endDate == null) Text(' - ${texts.current}', style: textTheme.bodyMediumTextStyle),
              ]),
              if (experience.summary != null && experience.summary!.isNotEmpty) ...[
                SizedBox(height: config.lineSpace),
                Text(texts.responsibilities, style: textTheme.bodySmallTextStyle),
                SizedBox(height: config.lineSpace),
                Text(experience.summary!, style: textTheme.paragraphTextStyle),
              ],
              if (index < resume.workExperience.length - 1) SizedBox(height: config.innerSpace),
            ],
          ),
        );
      },
    ),
  ];
}
