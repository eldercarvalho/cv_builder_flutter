import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
import '../../constants.dart';
import '../../template_config.dart';
import 'certifications_section.dart';
import 'contact_section.dart';
import 'education_section.dart';
import 'experience_section.dart';
import 'languages_section.dart';
import 'objective_section.dart';
import 'skills_section.dart';

List<Widget> buildSection({
  required Resume resume,
  required ResumeSection section,
  required TemplateConfig config,
  required TemplateColumn column,
}) {
  return switch (section.type) {
    ResumeSectionType.contact => buildContact(resume: resume, config: config, column: column),
    ResumeSectionType.objective => buildObjective(resume: resume, config: config, column: column),
    ResumeSectionType.experience => buildExperience(resume: resume, config: config, column: column),
    ResumeSectionType.education => buildEducation(resume: resume, config: config, column: column),
    ResumeSectionType.skills => buildSkills(resume: resume, config: config, column: column),
    ResumeSectionType.languages => buildLanguages(resume: resume, config: config, column: column),
    ResumeSectionType.certifications => buildCertifications(resume: resume, config: config, column: column),
    ResumeSectionType.projects => [],
    ResumeSectionType.socialNetworks => [],
    ResumeSectionType.hobbies => [],
    ResumeSectionType.references => [],
    ResumeSectionType.address => [],
  };
}
