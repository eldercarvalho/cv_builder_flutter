import 'package:cv_builder/domain/templates/texts.dart';
import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../icons.dart';
import '../../template_config.dart';
import 'section_title.dart';

List<Widget> buildExperience({required Resume resume, required TemplateConfig config}) {
  final ResumeSection sectionConfig = resume.sections.experience;
  final resumeLanguage = resume.resumeLanguage!.name;
  final texts = getTexts(resume.resumeLanguage!);
  final colors = resume.theme.primaryColors;

  if (resume.workExperience.isEmpty) {
    return [];
  }

  return [
    if (sectionConfig.forcePageBreak) NewPage(),
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config, hideDivider: sectionConfig.hideDivider),
      SizedBox(height: config.titleSpace),
    ],
    ...List.generate(
      resume.workExperience.length,
      (index) {
        final experience = resume.workExperience[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Expanded(child: Text(experience.position, style: config.leftTextTheme.titleXSmallTextStyle)),
              Text(experience.startDate.toShortDate(locale: resumeLanguage),
                  style: config.leftTextTheme.bodyMediumTextStyle),
              if (experience.endDate != null)
                Text(' - ${experience.endDate!.toShortDate(locale: resumeLanguage)}',
                    style: config.leftTextTheme.bodyMediumTextStyle),
              if (experience.endDate == null)
                Text(' - ${texts.current}', style: config.leftTextTheme.bodyMediumTextStyle),
            ]),
            SizedBox(height: config.lineSpace),
            Row(
              children: [
                Flexible(child: Text(experience.company, style: config.leftTextTheme.bodyMediumTextStyle)),
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
            if (experience.summary != null && experience.summary!.isNotEmpty) ...[
              SizedBox(height: config.lineSpace),
              Text(texts.responsibilities, style: config.leftTextTheme.bodySmallTextStyle),
              SizedBox(height: config.lineSpace),
              Text(experience.summary!, style: config.leftTextTheme.paragraphTextStyle),
            ],
            if (index < resume.workExperience.length - 1) SizedBox(height: config.innerSpace),
          ],
        );
      },
    ),
  ];
}
