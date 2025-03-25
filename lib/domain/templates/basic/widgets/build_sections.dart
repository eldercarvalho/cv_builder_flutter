import 'package:pdf/widgets.dart';

import '../../../models/resume.dart';
import '../../../models/resume_section.dart';
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
}) {
  return switch (section.type) {
    ResumeSectionType.contact => buildContact(resume: resume, config: config),
    ResumeSectionType.objective => buildObjective(resume: resume, config: config),
    ResumeSectionType.experience => buildExperience(resume: resume, config: config),
    ResumeSectionType.education => buildEducation(resume: resume, config: config),
    ResumeSectionType.skills => buildSkills(resume: resume, config: config),
    ResumeSectionType.languages => buildLanguages(resume: resume, config: config),
    ResumeSectionType.certifications => buildCertifications(resume: resume, config: config),
    ResumeSectionType.projects => [],
    ResumeSectionType.socialNetworks => [],
    ResumeSectionType.hobbies => [],
    ResumeSectionType.references => [],
    ResumeSectionType.address => [],
  };
}
