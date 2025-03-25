import 'package:equatable/equatable.dart';

import 'resume.dart';

class ResumeTextTheme extends Equatable {
  final ResumeLanguage language;
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

  const ResumeTextTheme({
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

  ResumeTextTheme copyWith({
    ResumeLanguage? language,
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
    return ResumeTextTheme(
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

  @override
  List<Object?> get props => [
        language,
        objective,
        experience,
        education,
        skills,
        languages,
        certifications,
        projects,
        contact,
        references,
        hobbies,
      ];
}
