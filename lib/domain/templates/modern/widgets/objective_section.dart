import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../constants.dart';
import '../../template_config.dart';
import 'box.dart';
import 'section_title.dart';

List<Widget> buildObjective({
  required Resume resume,
  required TemplateConfig config,
  required TemplateColumn column,
}) {
  final ResumeSection sectionConfig = resume.sections.objective;
  final textTheme = switch (column) {
    TemplateColumn.one => config.leftTextTheme,
    TemplateColumn.two => config.rightTextTheme,
  };

  if (resume.objectiveSummary == null || resume.objectiveSummary!.isEmpty) {
    return [];
  }

  return [
    if (!sectionConfig.hideTitle) ...[
      SectionTitle(text: sectionConfig.title, config: config, column: column, hideDivider: sectionConfig.hideDivider),
      SizedBox(height: config.titleSpace),
    ],
    Box(child: Text(resume.objectiveSummary!, style: textTheme.paragraphTextStyle)),
  ];
}
