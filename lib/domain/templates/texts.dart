import '../models/resume.dart';

class TemplateTexts {
  final String years;
  final String objective;
  final String experience;
  final String education;
  final String skills;
  final String languages;
  final String certifications;
  final String projects;
  final String contact;
  final String references;
  final String hobbies;
  final String responsibilities;
  final String current;

  TemplateTexts({
    required this.years,
    required this.objective,
    required this.experience,
    required this.education,
    required this.skills,
    required this.languages,
    required this.certifications,
    required this.projects,
    required this.contact,
    required this.references,
    required this.hobbies,
    required this.responsibilities,
    required this.current,
  });
}

TemplateTexts getTexts(ResumeLanguage language) {
  return switch (language) {
    ResumeLanguage.pt => TemplateTexts(
        years: 'anos',
        contact: 'Contato',
        objective: 'Objetivo',
        experience: 'Experiência Profissional',
        skills: 'Conhecimentos',
        education: 'Formação',
        languages: 'Idiomas',
        certifications: 'Certificações',
        projects: 'Projetos',
        references: 'Referências',
        hobbies: 'Interesses',
        responsibilities: 'Atividades:',
        current: 'Presente',
      ),
    ResumeLanguage.en => TemplateTexts(
        years: 'years',
        contact: 'Contact',
        objective: 'Objective',
        experience: 'Experience',
        skills: 'Skills',
        education: 'Education',
        languages: 'Languages',
        certifications: 'Certifications',
        projects: 'Projects',
        references: 'References',
        hobbies: 'Hobbies',
        responsibilities: 'Activities:',
        current: 'Present',
      ),
    ResumeLanguage.es => TemplateTexts(
        years: 'años',
        contact: 'Contacto',
        objective: 'Objetivo',
        experience: 'Experiencia',
        skills: 'Habilidades',
        education: 'Educación',
        languages: 'Idiomas',
        certifications: 'Certificaciones',
        projects: 'Proyectos',
        references: 'Referencias',
        hobbies: 'Intereses',
        responsibilities: 'Actividades:',
        current: 'Actual',
      ),
  };
}
