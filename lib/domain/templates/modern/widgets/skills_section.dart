import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../constants.dart';
import '../../template_config.dart';
import 'section_title.dart';

List<Widget> buildSkills({
  required Resume resume,
  required TemplateConfig config,
  required TemplateColumn column,
}) {
  final ResumeSection sectionConfig = resume.sections.skills;

  final textTheme = switch (column) {
    TemplateColumn.one => config.leftTextTheme,
    TemplateColumn.two => config.rightTextTheme,
  };

  final colors = switch (column) {
    TemplateColumn.one => config.theme.primaryColors,
    TemplateColumn.two => config.theme.secondaryColors,
  };

  if (resume.skills.isEmpty) {
    return [];
  }

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config, column: column),
      SizedBox(height: config.titleSpace),
    ],
    ...List.generate(
      resume.skills.length,
      (index) {
        final skill = resume.skills[index];
        return Bullet(
          text: skill.name + (skill.level != null && skill.level!.isNotEmpty ? ' - ${skill.level}' : ''),
          style: textTheme.bodyMediumTextStyle.copyWith(lineSpacing: 1),
          bulletColor: PdfColor.fromHex(colors.textColor),
          padding: const EdgeInsets.only(left: 6, right: 16),
        );
      },
    ),
  ];
}
