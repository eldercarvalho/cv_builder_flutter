import 'package:equatable/equatable.dart';

import '../../domain/models/resume.dart';
import 'award.dart';
import 'certification.dart';
import 'education.dart';
import 'hobbie.dart';
import 'language.dart';
import 'project.dart';
import 'reference.dart';
import 'resume_section.dart';
import 'resume_text_theme.dart';
import 'resume_theme.dart';
import 'skill.dart';
import 'social_network.dart';
import 'work_experience.dart';

class ResumeModel extends Equatable {
  final String id;
  final bool isActive;
  final String resumeName;
  final String resumeLanguage;
  final String name;
  final String? profession;
  final String? birthDate;
  final String? photo;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? phoneNumber;
  final String? website;
  final String? email;
  final String? objectiveSummary;
  final List<SocialNetworkModel> socialNetworks;
  final List<WorkExperienceModel> workExperience;
  final List<EducationModel> education;
  final List<ProjectModel> projects;
  final List<AwardModel> awards;
  final List<CertificationModel> certifications;
  final List<SkillModel> skills;
  final List<HobbieModel> hobbies;
  final List<LanguageModel> languages;
  final List<ReferenceModel> references;
  final String template;
  final String createdAt;
  final String? updatedAt;
  final String? thumbnail;
  final ResumeThemeModel? theme;
  final List<ResumeSectionModel> sections;
  final String? copyId;

  const ResumeModel({
    required this.id,
    required this.isActive,
    required this.resumeName,
    required this.resumeLanguage,
    required this.name,
    this.profession,
    this.birthDate,
    this.photo,
    this.address,
    this.city,
    this.zipCode,
    this.phoneNumber,
    this.website,
    this.email,
    this.objectiveSummary,
    this.socialNetworks = const [],
    this.workExperience = const [],
    this.education = const [],
    this.projects = const [],
    this.awards = const [],
    this.certifications = const [],
    this.skills = const [],
    this.hobbies = const [],
    this.languages = const [],
    this.references = const [],
    required this.template,
    required this.createdAt,
    this.updatedAt,
    this.thumbnail,
    this.theme,
    this.sections = const [],
    this.copyId,
  });

  static const ResumeModel empty = ResumeModel(
    id: '',
    isActive: true,
    resumeName: '',
    resumeLanguage: '',
    name: '',
    template: 'simple',
    createdAt: '',
  );

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] as String,
      isActive: json['isActive'] as bool,
      resumeName: json['resumeName'] as String,
      resumeLanguage: json['resumeLanguage'] as String,
      name: json['name'] as String,
      profession: json['profession'] as String?,
      birthDate: json['birthDate'] as String?,
      photo: json['image'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      zipCode: json['zipCode'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      website: json['website'] as String?,
      email: json['email'] as String?,
      socialNetworks: List.of(json['socialNetworks']).map((e) => SocialNetworkModel.fromJson(e)).toList(),
      objectiveSummary: json['objectiveSummary'] as String?,
      workExperience: (json['workExperience'] as List<dynamic>)
          .map((e) => WorkExperienceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: List.of(json['education']).map((e) => EducationModel.fromJson(e)).toList(),
      projects:
          (json['projects'] as List<dynamic>).map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList(),
      awards: (json['awards'] as List<dynamic>).map((e) => AwardModel.fromJson(e as Map<String, dynamic>)).toList(),
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      skills: (json['skills'] as List<dynamic>).map((e) => SkillModel.fromJson(e as Map<String, dynamic>)).toList(),
      hobbies: (json['hobbies'] as List<dynamic>).map((e) => HobbieModel.fromJson(e as Map<String, dynamic>)).toList(),
      languages:
          (json['languages'] as List<dynamic>).map((e) => LanguageModel.fromJson(e as Map<String, dynamic>)).toList(),
      references:
          (json['references'] as List<dynamic>).map((e) => ReferenceModel.fromJson(e as Map<String, dynamic>)).toList(),
      template: json['model'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      thumbnail: json['thumbnail'] as String?,
      theme: json['theme'] != null
          ? ResumeThemeModel.fromJson(json['theme'], json['model'])
          : ResumeThemeModel.getByTemplate(json['model']),
      sections: json['sections'] != null
          ? List.of(json['sections'] ?? []).map((e) => ResumeSectionModel.fromJson(e)).toList()
          : ResumeSectionModel.getSectionsByTemplate(json['model']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isActive': isActive,
      'resumeName': resumeName,
      'resumeLanguage': resumeLanguage,
      'name': name,
      'profession': profession,
      'birthDate': birthDate,
      'image': photo,
      'address': address,
      'city': city,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      'website': website,
      'email': email,
      'socialNetworks': socialNetworks.map((e) => e.toJson()).toList(),
      'objectiveSummary': objectiveSummary,
      'workExperience': workExperience.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'projects': projects.map((e) => e.toJson()).toList(),
      'awards': awards.map((e) => e.toJson()).toList(),
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'hobbies': hobbies.map((e) => e.toJson()).toList(),
      'languages': languages.map((e) => e.toJson()).toList(),
      'references': references.map((e) => e.toJson()).toList(),
      'model': template,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'thumbnail': thumbnail,
      'theme': theme?.toJson(),
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }

  Resume toDomain() {
    return Resume(
      id: id,
      isActive: isActive,
      resumeName: resumeName,
      resumeLanguage: ResumeLanguage.fromString(resumeLanguage),
      name: name,
      profession: profession,
      birthDate: birthDate != null ? DateTime.parse(birthDate!) : null,
      photo: photo,
      address: address,
      city: city,
      zipCode: zipCode,
      phoneNumber: phoneNumber,
      website: website,
      email: email,
      socialNetworks: socialNetworks.map((e) => e.toDomain()).toList(),
      objectiveSummary: objectiveSummary,
      workExperience: workExperience.map((e) => e.toDomain()).toList(),
      education: education.map((e) => e.toDomain()).toList(),
      projects: projects.map((e) => e.toDomain()).toList(),
      awards: awards.map((e) => e.toDomain()).toList(),
      certifications: certifications.map((e) => e.toDomain()).toList(),
      skills: skills.map((e) => e.toDomain()).toList(),
      hobbies: hobbies.map((e) => e.toDomain()).toList(),
      languages: languages.map((e) => e.toDomain()).toList(),
      references: references.map((e) => e.toDomain()).toList(),
      template: ResumeTemplate.fromString(template),
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
      thumbnail: thumbnail,
      theme: theme != null ? theme!.toDomain() : ResumeTheme.basic,
      sections: sections.map((e) => e.toDomain()).toList(),
    );
  }

  factory ResumeModel.fromDomain(Resume resume) {
    return ResumeModel(
      id: resume.id,
      isActive: resume.isActive,
      resumeName: resume.resumeName,
      resumeLanguage: resume.resumeLanguage != null ? resume.resumeLanguage!.name : '',
      name: resume.name,
      photo: resume.photo,
      profession: resume.profession,
      birthDate: resume.birthDate?.toIso8601String(),
      address: resume.address,
      city: resume.city,
      zipCode: resume.zipCode,
      phoneNumber: resume.phoneNumber,
      website: resume.website,
      email: resume.email,
      socialNetworks: resume.socialNetworks.map((e) => SocialNetworkModel.fromDomain(e)).toList(),
      objectiveSummary: resume.objectiveSummary,
      workExperience: resume.workExperience.map((e) => WorkExperienceModel.fromDomain(e)).toList(),
      education: resume.education.map((e) => EducationModel.fromDomain(e)).toList(),
      projects: resume.projects.map((e) => ProjectModel.fromDomain(e)).toList(),
      awards: resume.awards.map((e) => AwardModel.fromDomain(e)).toList(),
      certifications: resume.certifications.map((e) => CertificationModel.fromDomain(e)).toList(),
      skills: resume.skills.map((e) => SkillModel.fromDomain(e)).toList(),
      hobbies: resume.hobbies.map((e) => HobbieModel.fromDomain(e)).toList(),
      languages: resume.languages.map((e) => LanguageModel.fromDomain(e)).toList(),
      references: resume.references.map((e) => ReferenceModel.fromDomain(e)).toList(),
      template: resume.template.name,
      createdAt: resume.createdAt.toIso8601String(),
      updatedAt: resume.updatedAt?.toIso8601String(),
      thumbnail: resume.thumbnail,
      theme: ResumeThemeModel.fromDomain(resume.theme),
      sections: resume.sections.map((e) => ResumeSectionModel.fromDomain(e)).toList(),
      copyId: resume.copyId,
    );
  }

  ResumeModel copyWith({
    String? id,
    bool? isActive,
    String? resumeName,
    String? resumeLanguage,
    String? name,
    String? profession,
    String? birthDate,
    String? photo,
    String? address,
    String? city,
    String? zipCode,
    String? phoneNumber,
    String? website,
    String? email,
    List<SocialNetworkModel>? socialNetworks,
    String? objectiveSummary,
    List<WorkExperienceModel>? workExperience,
    List<EducationModel>? education,
    List<ProjectModel>? projects,
    List<AwardModel>? awards,
    List<CertificationModel>? certifications,
    List<SkillModel>? skills,
    List<HobbieModel>? hobbies,
    List<LanguageModel>? languages,
    List<ReferenceModel>? references,
    String? template,
    String? createdAt,
    String? updatedAt,
    String? thumbnail,
    ResumeThemeModel? theme,
    List<ResumeTextThemeModel>? texts,
    List<ResumeSectionModel>? sections,
    String? copyId,
  }) {
    return ResumeModel(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      resumeName: resumeName ?? this.resumeName,
      resumeLanguage: resumeLanguage ?? this.resumeLanguage,
      name: name ?? this.name,
      profession: profession ?? this.profession,
      birthDate: birthDate ?? this.birthDate,
      photo: photo ?? this.photo,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      email: email ?? this.email,
      socialNetworks: socialNetworks ?? this.socialNetworks,
      objectiveSummary: objectiveSummary ?? this.objectiveSummary,
      workExperience: workExperience ?? this.workExperience,
      education: education ?? this.education,
      projects: projects ?? this.projects,
      awards: awards ?? this.awards,
      certifications: certifications ?? this.certifications,
      skills: skills ?? this.skills,
      hobbies: hobbies ?? this.hobbies,
      languages: languages ?? this.languages,
      references: references ?? this.references,
      template: template ?? this.template,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      thumbnail: thumbnail ?? this.thumbnail,
      theme: theme ?? this.theme,
      sections: sections ?? this.sections,
      copyId: copyId ?? this.copyId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        isActive,
        resumeName,
        resumeLanguage,
        name,
        profession,
        birthDate,
        address,
        city,
        zipCode,
        phoneNumber,
        website,
        email,
        socialNetworks,
        objectiveSummary,
        workExperience,
        education,
        projects,
        awards,
        certifications,
        skills,
        hobbies,
        languages,
        references,
        template,
        createdAt,
        updatedAt,
        thumbnail,
        theme,
        sections,
        copyId,
      ];
}
