import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
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
  final String? address;
  final String? city;
  final String? zipCode;
  final String? phoneNumber;
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
    this.isDraft = false,
    this.copyId,
    this.theme = ResumeTheme.basic,
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

  static Resume fake() => Resume(
        id: const Uuid().v4(),
        isActive: true,
        resumeName: 'Currículo 1',
        name: 'João Francisco da Silva',
        profession: 'Desenvolvedor Mobile',
        birthDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
        // photo:
        //     'https://firebasestorage.googleapis.com/v0/b/cvbuilder-67b67.firebasestorage.app/o/user_photo.png?alt=media&token=d7228e79-a5a4-4efc-bd45-d9c9988dccf2',
        address: 'Rua dos Devs, 130',
        city: 'São Paulo',
        zipCode: '88050-400',
        phoneNumber: '11 988661-9110',
        website: 'https://joaosilva.com.br',
        email: 'joaofsilva@gmail.com',
        socialNetworks: const [
          SocialNetwork(
            id: '1',
            name: 'LinkedIn',
            username: 'joaofrancisco',
            url: 'https://www.linkedin.com/in/elder-carvalho-28753492/',
          ),
          SocialNetwork(
            id: '2',
            name: 'GitHub',
            username: 'joaofrancisco',
            url: 'https://github.com/eldercarvalho',
          ),
        ],
        objectiveSummary: Faker().lorem.sentences(6).join(' '),
        workExperience: [
          WorkExperience(
            id: '1',
            company: 'Google Inc.',
            position: 'Desenvolvedor Mobile Senior',
            startDate: DateTime.now().subtract(const Duration(days: 365)),
            endDate: null,
            website: Faker().internet.httpsUrl(),
            summary: Faker().lorem.sentences(6).join(' '),
          ),
          WorkExperience(
            id: '2',
            company: 'Amazon Inc.',
            position: 'Desenvolvedor Mobile Pleno',
            startDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
            endDate: DateTime.now().subtract(const Duration(days: 365)),
            website: Faker().internet.httpsUrl(),
            summary: Faker().lorem.sentences(6).join(' '),
          ),
          WorkExperience(
            id: '3',
            company: 'Apple Inc.',
            position: 'Desenvolvedor Mobile Júnior',
            startDate: DateTime.now().subtract(const Duration(days: 365 * 3)),
            endDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
            website: Faker().internet.httpsUrl(),
            summary: Faker().lorem.sentences(6).join(' '),
          ),
        ],
        education: [
          Education(
            id: '1',
            institution: 'UNIP',
            typeOfDegree: 'Bacharelado',
            fieldOfStudy: 'Ciência da Computação',
            startDate: DateTime.parse('2012-01-01'),
            endDate: DateTime.parse('2016-12-30'),
            summary: '',
          ),
        ],
        projects: [
          Project(
            id: '1',
            title: 'Projeto 1',
            startDate: DateTime.parse('2021-01-01'),
            endDate: DateTime.parse('2021-12-31'),
            summary: Faker().lorem.sentences(3).join(' '),
          ),
          Project(
            id: '2',
            title: 'Projeto 2',
            startDate: DateTime.parse('2022-01-01'),
            endDate: DateTime.parse('2022-12-31'),
            summary: Faker().lorem.sentences(3).join(' '),
          ),
        ],
        awards: [
          Award(
            id: '1',
            title: 'Prêmio 1',
            date: DateTime.parse('2021-01-01'),
            awarder: 'Emissor 1',
            summary: '',
          ),
          Award(
            id: '2',
            title: 'Prêmio 2',
            date: DateTime.parse('2021-01-01'),
            summary: '',
            awarder: 'Emissor 2',
          ),
        ],
        certifications: [
          Certification(
            id: '1',
            title: 'Curso de Android',
            date: DateTime.parse('2021-01-01'),
            summary: Faker().lorem.sentences(3).join(' '),
            issuer: 'Udemy',
          ),
          // Certification(
          //   id: '2',
          //   title: 'Certificado 2',
          //   date: DateTime.parse('2021-01-01'),
          //   summary: Faker().lorem.sentences(3).join(' '),
          //   issuer: 'Emissor 2',
          // ),
        ],
        skills: const [
          Skill(
            id: '1',
            name: 'Android',
            level: 'Avançado',
          ),
          Skill(
            id: '2',
            name: 'Kotlin',
            level: 'Avançado',
          ),
          Skill(
            id: '3',
            name: 'React',
            level: 'Intermediário',
          ),
          Skill(
            id: '4',
            name: 'JavaScript',
            level: 'Avançado',
          ),
          Skill(
            id: '5',
            name: 'Git',
            level: 'Avançado',
          ),
          Skill(
            id: '6',
            name: 'Clean Architecture',
            level: 'Avançado',
          ),
          Skill(
            id: '7',
            name: 'CI/CD',
            level: 'Avançado',
          ),
        ],
        hobbies: const [
          Hobbie(
            id: '1',
            name: 'Hobbie 1',
          ),
        ],
        languages: const [
          Language(
            id: '1',
            name: 'Português',
            fluency: 'Nativo',
          ),
          Language(
            id: '2',
            name: 'Inglês',
            fluency: 'Intermediário B2',
          ),
        ],
        references: [
          Reference(
            id: '1',
            name: 'Reference 1',
            position: 'Position 1',
            phoneNumber: '48 98851-9100',
            email: Faker().internet.email(),
            summary: Faker().lorem.sentences(2).join(' '),
          ),
        ],
        template: ResumeTemplate.modern,
        createdAt: DateTime.now(),
      );

  Resume copyWith({
    String? id,
    bool? isActive,
    String? resumeName,
    ResumeLanguage? resumeLanguage,
    String? name,
    String? profession,
    DateTime? birthDate,
    String? photo,
    bool setNullPhoto = false,
    String? address,
    String? city,
    String? zipCode,
    String? phoneNumber,
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
  }) {
    return Resume(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      resumeName: resumeName ?? this.resumeName,
      resumeLanguage: resumeLanguage ?? this.resumeLanguage,
      name: name ?? this.name,
      profession: profession ?? this.profession,
      birthDate: birthDate ?? this.birthDate,
      photo: setNullPhoto ? null : photo ?? this.photo,
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
      isDraft: isDraft ?? this.isDraft,
      copyId: copyId ?? this.copyId,
      theme: theme ?? this.theme,
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
        photo,
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
        isDraft,
        copyId,
        theme,
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
  final List<ResumeColor> primaryColors;
  final List<ResumeColor> secondaryColors;

  const ResumeTheme({
    required this.primaryColors,
    this.secondaryColors = const [],
  });

  static const ResumeTheme basic = ResumeTheme(
    primaryColors: [
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
    List<ResumeColor>? primaryColors,
    List<ResumeColor>? secondaryColors,
  }) {
    return ResumeTheme(
      primaryColors: primaryColors ?? this.primaryColors,
      secondaryColors: secondaryColors ?? this.secondaryColors,
    );
  }

  @override
  List<Object?> get props => [
        primaryColors,
        secondaryColors,
      ];
}

extension ResumeColorListExtension on List<ResumeColor> {
  String get backgroundColor => firstWhere((color) => color.type == ResumeColorType.background).value;
  String get titleColor => firstWhere((color) => color.type == ResumeColorType.title).value;
  String get textColor => firstWhere((color) => color.type == ResumeColorType.text).value;
  String get iconColor => firstWhere((color) => color.type == ResumeColorType.icon).value;
  String get linkColor => firstWhere((color) => color.type == ResumeColorType.link).value;
  String get dividerColor => firstWhere((color) => color.type == ResumeColorType.divider).value;

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
