import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../template_config.dart';
import 'section_title.dart';

List<Widget> buildLanguages({required Resume resume, required TemplateConfig config}) {
  final ResumeSection sectionConfig = resume.sections.languages;

  if (resume.languages.isEmpty) {
    return [SizedBox.shrink()];
  }

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config),
      SizedBox(height: config.titleSpace),
    ],
    ...List.generate(resume.languages.length, (index) {
      final language = resume.languages[index];
      return Padding(
          padding: EdgeInsets.only(bottom: index < resume.languages.length - 1 ? 1.8 : 0),
          child: Row(
            children: [
              Text(language.name, style: config.leftTextTheme.titleXSmallTextStyle),
              if (language.fluency != null && language.fluency!.isNotEmpty)
                Text(' - ${language.fluency}', style: config.leftTextTheme.bodyMediumTextStyle),
            ],
          ));
    }),
  ];
}
