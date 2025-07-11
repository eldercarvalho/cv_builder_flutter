import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../template_config.dart';
import 'section_title.dart';

List<Widget> buildObjective({required Resume resume, required TemplateConfig config}) {
  final ResumeSection sectionConfig = resume.sections.objective;

  if (resume.objectiveSummary == null || resume.objectiveSummary!.isEmpty) {
    return [];
  }

  return [
    if (sectionConfig.forcePageBreak) NewPage(),
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config, hideDivider: sectionConfig.hideDivider),
      SizedBox(height: config.titleSpace),
    ],
    Text(resume.objectiveSummary!, style: config.leftTextTheme.paragraphTextStyle),
  ];
}
