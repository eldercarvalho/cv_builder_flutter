import '../../domain/models/resume.dart';
import '../../domain/models/resume_text_theme.dart';

class ResumeTextThemeModel {
  final String language;
  final String? objective;
  final String? experience;
  final String? education;
  final String? skills;
  final String? languages;
  final String? certifications;
  final String? projects;
  final String? contact;
  final String? references;
  final String? hobbies;

  const ResumeTextThemeModel({
    required this.language,
    this.objective,
    this.experience,
    this.education,
    this.skills,
    this.languages,
    this.certifications,
    this.projects,
    this.contact,
    this.references,
    this.hobbies,
  });

  ResumeTextThemeModel copyWith({
    String? language,
    String? objective,
    String? experience,
    String? education,
    String? skills,
    String? languages,
    String? certifications,
    String? projects,
    String? contact,
    String? references,
    String? hobbies,
  }) {
    return ResumeTextThemeModel(
      language: language ?? this.language,
      objective: objective ?? this.objective,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      certifications: certifications ?? this.certifications,
      projects: projects ?? this.projects,
      contact: contact ?? this.contact,
      references: references ?? this.references,
      hobbies: hobbies ?? this.hobbies,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'language': language,
      'objective': objective,
      'experience': experience,
      'education': education,
      'skills': skills,
      'languages': languages,
      'certifications': certifications,
      'projects': projects,
      'contact': contact,
      'references': references,
      'hobbies': hobbies,
    };
  }

  factory ResumeTextThemeModel.fromJson(Map<String, dynamic> map) {
    return ResumeTextThemeModel(
      language: map['language'] as String,
      objective: map['objective'] != null ? map['objective'] as String : null,
      experience: map['experience'] != null ? map['experience'] as String : null,
      education: map['education'] != null ? map['education'] as String : null,
      skills: map['skills'] != null ? map['skills'] as String : null,
      languages: map['languages'] != null ? map['languages'] as String : null,
      certifications: map['certifications'] != null ? map['certifications'] as String : null,
      projects: map['projects'] != null ? map['projects'] as String : null,
      contact: map['contact'] != null ? map['contact'] as String : null,
      references: map['references'] != null ? map['references'] as String : null,
      hobbies: map['hobbies'] != null ? map['hobbies'] as String : null,
    );
  }

  ResumeTextTheme toDomain() {
    return ResumeTextTheme(
      language: ResumeLanguage.fromString(language),
      objective: objective,
      experience: experience,
      education: education,
      skills: skills,
      languages: languages,
      certifications: certifications,
      projects: projects,
      contact: contact,
      references: references,
      hobbies: hobbies,
    );
  }

  static ResumeTextThemeModel fromDomain(ResumeTextTheme resume) {
    return ResumeTextThemeModel(
      language: resume.language.toString(),
      objective: resume.objective,
      experience: resume.experience,
      education: resume.education,
      skills: resume.skills,
      languages: resume.languages,
      certifications: resume.certifications,
      projects: resume.projects,
      contact: resume.contact,
      references: resume.references,
      hobbies: resume.hobbies,
    );
  }
}
