import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../template_config.dart';
import 'section_title.dart';

List<Widget> buildSkills({required Resume resume, required TemplateConfig config}) {
  final ResumeSection sectionConfig = resume.sections.skills;

  if (resume.skills.isEmpty) {
    return [];
  }

  return [
    if (sectionConfig.forcePageBreak) NewPage(),
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config, hideDivider: sectionConfig.hideDivider),
      SizedBox(height: config.titleSpace),
    ],
    if (sectionConfig.layout == ResumeSectionLayout.grid)
      Wrap(
        children: List.generate(
          resume.skills.length,
          (index) {
            final skill = resume.skills[index];
            final topPadding = index < 4 ? 0.0 : config.innerSpace;
            return Container(
              width: (PdfPageFormat.a4.availableWidth / 4),
              padding: EdgeInsets.only(top: topPadding, left: index % 4 == 0 ? 0 : 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon(IconData(''), size: 10),
                  Text(skill.name, style: config.leftTextTheme.bodySmallTextStyle),
                  if (skill.level != null && skill.level!.isNotEmpty)
                    Text('${skill.level}', style: config.leftTextTheme.bodyXSmallTextStyle),
                ],
              ),
            );
          },
        ),
      ),
    if (sectionConfig.layout == ResumeSectionLayout.list) ...[
      ...resume.skills.map(
        (skill) => Bullet(
          text: skill.name + (skill.level != null && skill.level!.isNotEmpty ? ' - ${skill.level}' : ''),
          padding: const EdgeInsets.only(left: -10),
          // style: config.leftTextTheme.bodySmallTextStyle,
        ),
      ),
    ],
  ];
}
