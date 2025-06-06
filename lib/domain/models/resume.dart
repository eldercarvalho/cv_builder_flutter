import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../templates/basic/basic.dart';
import '../templates/modern/modern.dart';
import 'award.dart';
import 'certification.dart';
import 'education.dart';
import 'hobbie.dart';
import 'language.dart';
import 'project.dart';
import 'reference.dart';
import 'resume_section.dart';
import 'resume_text_theme.dart';
import 'skill.dart';
import 'social_network.dart';
import 'work_experience.dart';

enum ResumeTemplate {
  basic('basic'),
  // elegant('elegant'),
  modern('modern');

  final String value;
  const ResumeTemplate(this.value);

  static ResumeTemplate fromString(String value) {
    switch (value) {
      case 'basic':
        return ResumeTemplate.basic;
      // case 'elegant':
      //   return ResumeTemplate.elegant;
      case 'modern':
        return ResumeTemplate.modern;
      default:
        return ResumeTemplate.basic;
    }
  }

  static ResumeTemplate fromIndex(int index) {
    switch (index) {
      case 0:
        return ResumeTemplate.basic;
      case 1:
        return ResumeTemplate.modern;
      // case 1:
      //   return ResumeTemplate.elegant;
      default:
        return ResumeTemplate.basic;
    }
  }
}

enum ResumeLanguage {
  pt,
  en,
  es;

  static ResumeLanguage fromString(String value) {
    switch (value) {
      case 'en':
        return ResumeLanguage.en;
      case 'es':
        return ResumeLanguage.es;
      default:
        return ResumeLanguage.pt;
    }
  }
}

class Resume extends Equatable {
  final String id;
  final bool isActive;
  final String resumeName;
  final ResumeLanguage? resumeLanguage;
  final String name;
  final String? profession;
  final String? photo;
  final DateTime? birthDate;
  final String? document;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? phoneNumber;
  final String? phoneNumber2;
  final String? website;
  final String? email;
  final String? objectiveSummary;
  final List<SocialNetwork> socialNetworks;
  final List<WorkExperience> workExperience;
  final List<Education> education;
  final List<Project> projects;
  final List<Award> awards;
  final List<Certification> certifications;
  final List<Skill> skills;
  final List<Hobbie> hobbies;
  final List<Language> languages;
  final List<Reference> references;
  final ResumeTemplate template;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? thumbnail;
  final bool isDraft;
  final String? copyId;
  final ResumeTheme theme;
  final List<ResumeTextTheme> texts;
  final List<ResumeSection> sections;

  String? get age => birthDate != null ? (DateTime.now().difference(birthDate!).inDays ~/ 365).toString() : null;
  bool get hasPhoto => photo != null;
  bool get isNetworkPhoto => photo != null && photo!.startsWith('http');
  String? get formattedAddress {
    String addressString = '';

    if (address != null && address!.isNotEmpty) {
      addressString += address!;
    }

    if (city != null && city!.isNotEmpty) {
      addressString += addressString.isNotEmpty ? ', $city' : city!;
    }

    if (zipCode != null && zipCode!.isNotEmpty) {
      addressString += addressString.isNotEmpty ? ' - $zipCode' : zipCode!;
    }

    return addressString;
  }

  const Resume({
    required this.id,
    required this.isActive,
    required this.resumeName,
    this.resumeLanguage,
    required this.name,
    this.profession,
    this.birthDate,
    this.document,
    this.photo,
    this.address,
    this.city,
    this.zipCode,
    this.phoneNumber,
    this.phoneNumber2,
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
    this.isDraft = false,
    this.copyId,
    this.theme = ResumeTheme.basic,
    this.texts = const [],
    this.sections = const [],
  });

  static Resume empty() => Resume(
        id: const Uuid().v4(),
        isActive: true,
        resumeName: '',
        name: '',
        template: ResumeTemplate.basic,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDraft: true,
      );

  static List<ResumeSection> createSectionsByTemplate({required ResumeTemplate template}) {
    switch (template) {
      case ResumeTemplate.basic:
        return [
          const ResumeSection(type: ResumeSectionType.contact, title: 'Contato', hideTitle: true),
          const ResumeSection(type: ResumeSectionType.objective, title: 'Objetivo'),
          const ResumeSection(type: ResumeSectionType.experience, title: 'Experiência Profissional'),
          const ResumeSection(type: ResumeSectionType.education, title: 'Formação'),
          const ResumeSection(type: ResumeSectionType.skills, title: 'Conhecimentos', hasLayout: true),
          const ResumeSection(type: ResumeSectionType.languages, title: 'Idiomas'),
          const ResumeSection(type: ResumeSectionType.certifications, title: 'Certificações'),
          // ResumeSection(type: ResumeSectionType.projects, title: 'Projetos'),
          // ResumeSection(type: ResumeSectionType.references, title: 'Referências'),
          // ResumeSection(type: ResumeSectionType.hobbies, title: 'Interesses'),
        ];
      case ResumeTemplate.modern:
        return [
          const ResumeSection(type: ResumeSectionType.contact, title: 'Contato'),
          const ResumeSection(type: ResumeSectionType.education, title: 'Formação'),
          const ResumeSection(type: ResumeSectionType.skills, title: 'Conhecimentos'),
          const ResumeSection(type: ResumeSectionType.languages, title: 'Idiomas'),
          const ResumeSection(type: ResumeSectionType.objective, title: 'Objetivo'),
          const ResumeSection(type: ResumeSectionType.experience, title: 'Experiência Profissional'),
          const ResumeSection(type: ResumeSectionType.certifications, title: 'Certificações'),
          // ResumeSection(type: ResumeSectionType.projects, title: 'Projetos'),
          // ResumeSection(type: ResumeSectionType.references, title: 'Referências'),
          // ResumeSection(type: ResumeSectionType.hobbies, title: 'Interesses'),
        ];
    }
  }

  static List<ResumeSection> setSectionTitles({
    required List<ResumeSection> sections,
    required String objectiveTitle,
    required String experienceTitle,
    required String educationTitle,
    required String skillsTitle,
    required String languagesTitle,
    required String certificationsTitle,
    required String projectsTitle,
    required String contactTitle,
    required String referencesTitle,
    required String hobbiesTitle,
  }) {
    return sections.map((section) {
      switch (section.type) {
        case ResumeSectionType.contact:
          return section.copyWith(title: contactTitle);
        case ResumeSectionType.objective:
          return section.copyWith(title: objectiveTitle);
        case ResumeSectionType.experience:
          return section.copyWith(title: experienceTitle);
        case ResumeSectionType.education:
          return section.copyWith(title: educationTitle);
        case ResumeSectionType.skills:
          return section.copyWith(title: skillsTitle);
        case ResumeSectionType.languages:
          return section.copyWith(title: languagesTitle);
        case ResumeSectionType.certifications:
          return section.copyWith(title: certificationsTitle);
        case ResumeSectionType.projects:
          return section.copyWith(title: projectsTitle);
        case ResumeSectionType.references:
          return section.copyWith(title: referencesTitle);
        case ResumeSectionType.hobbies:
          return section.copyWith(title: hobbiesTitle);
        case ResumeSectionType.socialNetworks:
          throw UnimplementedError();
        case ResumeSectionType.address:
          throw UnimplementedError();
      }
    }).toList();
  }

  static List<ResumeSection> orderSectionsByTemplate({
    required ResumeTemplate template,
    required List<ResumeSection> sections,
  }) {
    return switch (template) {
      ResumeTemplate.basic => [
          sections.getByType(ResumeSectionType.contact)!,
          sections.getByType(ResumeSectionType.objective)!,
          sections.getByType(ResumeSectionType.experience)!,
          sections.getByType(ResumeSectionType.skills)!,
          sections.getByType(ResumeSectionType.education)!,
          sections.getByType(ResumeSectionType.languages)!,
          sections.getByType(ResumeSectionType.certifications)!,
          // sections.getByType(ResumeSectionType.projects)!,
          // sections.getByType(ResumeSectionType.references)!,
          // sections.getByType(ResumeSectionType.hobbies)!,
        ],
      ResumeTemplate.modern => [
          sections.getByType(ResumeSectionType.contact)!,
          sections.getByType(ResumeSectionType.education)!,
          sections.getByType(ResumeSectionType.skills)!,
          sections.getByType(ResumeSectionType.languages)!,
          sections.getByType(ResumeSectionType.objective)!,
          sections.getByType(ResumeSectionType.experience)!,
          sections.getByType(ResumeSectionType.certifications)!,
          // sections.getByType(ResumeSectionType.projects)!,
          // sections.getByType(ResumeSectionType.references)!,
          // sections.getByType(ResumeSectionType.hobbies)!,
        ],
    };
  }

  Resume copyWith({
    String? id,
    bool? isActive,
    String? resumeName,
    ResumeLanguage? resumeLanguage,
    String? name,
    String? profession,
    bool setNullbirthDate = false,
    DateTime? birthDate,
    String? document,
    bool setNullDocument = false,
    String? photo,
    bool setNullPhoto = false,
    String? address,
    String? city,
    String? zipCode,
    String? phoneNumber,
    String? phoneNumber2,
    String? website,
    String? email,
    List<SocialNetwork>? socialNetworks,
    String? objectiveSummary,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<Project>? projects,
    List<Award>? awards,
    List<Certification>? certifications,
    List<Skill>? skills,
    List<Hobbie>? hobbies,
    List<Language>? languages,
    List<Reference>? references,
    ResumeTemplate? template,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? thumbnail,
    bool? isDraft,
    String? copyId,
    ResumeTheme? theme,
    List<ResumeTextTheme>? texts,
    List<ResumeSection>? sections,
  }) {
    return Resume(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      resumeName: resumeName ?? this.resumeName,
      resumeLanguage: resumeLanguage ?? this.resumeLanguage,
      name: name ?? this.name,
      profession: profession ?? this.profession,
      birthDate: setNullbirthDate ? null : birthDate ?? this.birthDate,
      document: setNullDocument ? null : document ?? this.document,
      photo: setNullPhoto ? null : photo ?? this.photo,
      address: address ?? this.address,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumber2: phoneNumber2 ?? this.phoneNumber2,
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
      isDraft: isDraft ?? this.isDraft,
      copyId: copyId ?? this.copyId,
      theme: theme ?? this.theme,
      texts: texts ?? this.texts,
      sections: sections ?? this.sections,
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
        document,
        photo,
        address,
        city,
        zipCode,
        phoneNumber,
        phoneNumber2,
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
        isDraft,
        copyId,
        theme,
        texts,
        sections,
      ];
}

extension ToPdfExtension on Resume {
  Future<Uint8List> toPdf() async {
    return switch (template) {
      ResumeTemplate.basic => BasicTemplate.generatePdf(this),
      ResumeTemplate.modern => ModernTemplate.generatePdf(this),
      // ResumeTemplate.elegant => BasicTemplate.generatePdf(this),
    };
  }

  Future<Uint8List> toThumbnail() async {
    return switch (template) {
      ResumeTemplate.basic => BasicTemplate.generateThumbnail(this),
      ResumeTemplate.modern => ModernTemplate.generateThumbnail(this),
      // ResumeTemplate.elegant => BasicTemplate.generateThumbnail(this),
    };
  }
}

enum ResumeColorType {
  background,
  link,
  title,
  text,
  icon,
  divider;

  static ResumeColorType fromString(String value) {
    switch (value) {
      case 'background':
        return ResumeColorType.background;
      case 'link':
        return ResumeColorType.link;
      case 'title':
        return ResumeColorType.title;
      case 'text':
        return ResumeColorType.text;
      case 'icon':
        return ResumeColorType.icon;
      case 'divider':
        return ResumeColorType.divider;
      default:
        return ResumeColorType.background;
    }
  }
}

class ResumeColor extends Equatable {
  final ResumeColorType type;
  final String value;

  const ResumeColor({
    required this.type,
    required this.value,
  });

  ResumeColor copyWith({
    ResumeColorType? type,
    String? value,
  }) {
    return ResumeColor(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [
        type,
        value,
      ];
}

class ResumeTheme extends Equatable {
  final bool singleLayout;
  final List<ResumeColor> primaryColors;
  final List<ResumeColor> secondaryColors;

  const ResumeTheme({
    this.singleLayout = false,
    required this.primaryColors,
    this.secondaryColors = const [],
  });

  static const ResumeTheme basic = ResumeTheme(
    singleLayout: true,
    primaryColors: [
      ResumeColor(type: ResumeColorType.background, value: '#FFFFFF'),
      ResumeColor(type: ResumeColorType.title, value: '#000000'),
      ResumeColor(type: ResumeColorType.text, value: '#000000'),
      ResumeColor(type: ResumeColorType.icon, value: '#000000'),
      ResumeColor(type: ResumeColorType.link, value: '#2196f3'),
      ResumeColor(type: ResumeColorType.divider, value: '#000000'),
    ],
    secondaryColors: [
      ResumeColor(type: ResumeColorType.background, value: '#FFFFFF'),
      ResumeColor(type: ResumeColorType.title, value: '#000000'),
      ResumeColor(type: ResumeColorType.text, value: '#000000'),
      ResumeColor(type: ResumeColorType.icon, value: '#000000'),
      ResumeColor(type: ResumeColorType.link, value: '#2196f3'),
      ResumeColor(type: ResumeColorType.divider, value: '#000000'),
    ],
  );

  static const ResumeTheme modern = ResumeTheme(
    primaryColors: [
      ResumeColor(type: ResumeColorType.background, value: '#D8DFE7'),
      ResumeColor(type: ResumeColorType.title, value: '#424242'),
      ResumeColor(type: ResumeColorType.text, value: '#424242'),
      ResumeColor(type: ResumeColorType.icon, value: '#424242'),
      ResumeColor(type: ResumeColorType.link, value: '#2196f3'),
      ResumeColor(type: ResumeColorType.divider, value: '#424242'),
    ],
    secondaryColors: [
      ResumeColor(type: ResumeColorType.background, value: '#FFFFFF'),
      ResumeColor(type: ResumeColorType.title, value: '#424242'),
      ResumeColor(type: ResumeColorType.text, value: '#424242'),
      ResumeColor(type: ResumeColorType.icon, value: '#424242'),
      ResumeColor(type: ResumeColorType.link, value: '#2196f3'),
      ResumeColor(type: ResumeColorType.divider, value: '#424242'),
    ],
  );

  static ResumeTheme getByTemplate(ResumeTemplate template) {
    switch (template) {
      case ResumeTemplate.basic:
        return basic;
      case ResumeTemplate.modern:
        return modern;
      // case ResumeTemplate.elegant:
      //   return elegant;
    }
  }

  static ResumeTheme getByString(String value) {
    switch (value) {
      case 'basic':
        return basic;
      case 'modern':
        return modern;
      // case 'elegant':
      //   return elegant;
      default:
        return basic;
    }
  }

  ResumeTheme copyWith({
    bool? multiple,
    List<ResumeColor>? primaryColors,
    List<ResumeColor>? secondaryColors,
  }) {
    return ResumeTheme(
      singleLayout: multiple ?? singleLayout,
      primaryColors: primaryColors ?? this.primaryColors,
      secondaryColors: secondaryColors ?? this.secondaryColors,
    );
  }

  @override
  List<Object?> get props => [
        singleLayout,
        primaryColors,
        secondaryColors,
      ];
}

extension ResumeColorListExtension on List<ResumeColor> {
  String get backgroundColor => firstWhere(
        (color) => color.type == ResumeColorType.background,
        orElse: () => const ResumeColor(type: ResumeColorType.background, value: '#FFFFFF'),
      ).value;
  String get titleColor => firstWhere(
        (color) => color.type == ResumeColorType.title,
        orElse: () => const ResumeColor(type: ResumeColorType.title, value: '#000000'),
      ).value;
  String get textColor => firstWhere(
        (color) => color.type == ResumeColorType.text,
        orElse: () => const ResumeColor(type: ResumeColorType.text, value: '#000000'),
      ).value;
  String get iconColor => firstWhere(
        (color) => color.type == ResumeColorType.icon,
        orElse: () => const ResumeColor(type: ResumeColorType.icon, value: '#000000'),
      ).value;
  String get linkColor => firstWhere(
        (color) => color.type == ResumeColorType.link,
        orElse: () => const ResumeColor(type: ResumeColorType.link, value: '#2196f3'),
      ).value;
  String get dividerColor => firstWhere(
        (color) => color.type == ResumeColorType.divider,
        orElse: () => const ResumeColor(type: ResumeColorType.divider, value: '#000000'),
      ).value;

  List<ResumeColor> setColor(ResumeColorType type, String value) {
    return map((e) => e.type == type ? e.copyWith(value: value) : e).toList();
  }

  List<ResumeColor> setBackgroundColor(String color) =>
      map((e) => e.type == ResumeColorType.background ? e.copyWith(value: color) : e).toList();
  List<ResumeColor> setLinkColor(String color) =>
      map((e) => e.type == ResumeColorType.link ? e.copyWith(value: color) : e).toList();
  List<ResumeColor> setTitleColor(String color) =>
      map((e) => e.type == ResumeColorType.title ? e.copyWith(value: color) : e).toList();
  List<ResumeColor> setTextColor(String color) =>
      map((e) => e.type == ResumeColorType.text ? e.copyWith(value: color) : e).toList();
  List<ResumeColor> setIconColor(String color) =>
      map((e) => e.type == ResumeColorType.icon ? e.copyWith(value: color) : e).toList();
  List<ResumeColor> setDividerColor(String color) =>
      map((e) => e.type == ResumeColorType.divider ? e.copyWith(value: color) : e).toList();
}
