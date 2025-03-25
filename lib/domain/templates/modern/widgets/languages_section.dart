import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../constants.dart';
import '../../template_config.dart';
import 'section_title.dart';

List<Widget> buildLanguages({
  required Resume resume,
  required TemplateConfig config,
  required TemplateColumn column,
}) {
  final ResumeSection sectionConfig = resume.sections.languages;

  final textTheme = switch (column) {
    TemplateColumn.one => config.leftTextTheme,
    TemplateColumn.two => config.rightTextTheme,
  };

  final colors = switch (column) {
    TemplateColumn.one => config.theme.primaryColors,
    TemplateColumn.two => config.theme.secondaryColors,
  };

  if (resume.languages.isEmpty) {
    return [];
  }

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config, column: column),
      SizedBox(height: config.titleSpace),
    ],
    ...List.generate(resume.languages.length, (index) {
      final language = resume.languages[index];
      return Bullet(
        text:
            language.name + (language.fluency != null && language.fluency!.isNotEmpty ? ' - ${language.fluency}' : ''),
        style: textTheme.bodyMediumTextStyle.copyWith(lineSpacing: 1),
        bulletColor: colors.textColor.toColor(),
        padding: const EdgeInsets.only(left: 6, right: 16),
      );
    }),
  ];
}
