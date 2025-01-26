import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';

import '../../ui/shared/resume_models/simple/simple.dart';
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
  simple,
  elegant,
  modern;

  static ResumeTemplate fromString(String value) {
    switch (value) {
      case 'simple':
        return ResumeTemplate.simple;
      case 'elegant':
        return ResumeTemplate.elegant;
      case 'modern':
        return ResumeTemplate.modern;
      default:
        return ResumeTemplate.simple;
    }
  }
}

class Resume extends Equatable {
  final String id;
  final bool isActive;
  final String resumeName;
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

  String? get age => birthDate != null ? (DateTime.now().difference(birthDate!).inDays ~/ 365).toString() : null;

  const Resume({
    required this.id,
    required this.isActive,
    required this.resumeName,
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
  });

  static Resume empty() => Resume(
        id: const Uuid().v4(),
        isActive: true,
        resumeName: '',
        name: '',
        template: ResumeTemplate.simple,
        createdAt: DateTime.now(),
      );

  static Resume fake() => Resume(
        id: const Uuid().v4(),
        isActive: true,
        resumeName: 'Currículo 1',
        name: 'Elder Amaral de Carvalho',
        profession: 'Desenvolvedor Mobile Flutter',
        birthDate: Faker().date.dateTime(),
        photo: 'https://fastly.picsum.photos/id/237/200/200.jpg?hmac=zHUGikXUDyLCCmvyww1izLK3R3k8oRYBRiTizZEdyfI',
        address: 'Rua Padre Lourenço Rodrigues de Andrade, 130',
        city: 'Florianópolis',
        zipCode: '88050-400',
        phoneNumber: '48 98851-9100',
        website: Faker().internet.httpsUrl(),
        email: Faker().internet.email(),
        socialNetworks: const [
          SocialNetwork(
            id: '1',
            name: 'LinkedIn',
            username: 'elder-carvalho-28753492',
            url: 'https://www.linkedin.com/in/elder-carvalho-28753492/',
          ),
          SocialNetwork(
            id: '2',
            name: 'GitHub',
            username: 'eldercarvalho',
            url: 'https://github.com/eldercarvalho',
          ),
        ],
        objectiveSummary: Faker().lorem.sentences(6).join(' '),
        workExperience: [
          WorkExperience(
            id: '1',
            company: 'Sasi Comunicação Ágil ltda',
            position: 'Desenvolvedor Mobile Flutter',
            startDate: DateTime.now().subtract(const Duration(days: 365)),
            endDate: null,
            website: Faker().internet.httpsUrl(),
            summary: Faker().lorem.sentences(5).join(' '),
          ),
          WorkExperience(
            id: '2',
            company: 'DOT Digital Group',
            position: 'Desenvolvedor Frontend',
            startDate: DateTime.now().subtract(const Duration(days: 730)),
            endDate: DateTime.now().subtract(const Duration(days: 365)),
            website: Faker().internet.httpsUrl(),
            summary: Faker().lorem.sentences(5).join(' '),
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
            title: 'Award 1',
            date: DateTime.parse('2021-01-01'),
            awarder: 'Issuer 1',
            summary: '',
          ),
          Award(
            id: '2',
            title: 'Award 2',
            date: DateTime.parse('2021-01-01'),
            summary: '',
            awarder: 'Issuer 2',
          ),
        ],
        certifications: [
          Certification(
            id: '1',
            title: 'Certification 1',
            date: DateTime.parse('2021-01-01'),
            summary: Faker().lorem.sentences(3).join(' '),
            issuer: 'Issuer 1',
          ),
          Certification(
            id: '2',
            title: 'Certification 2',
            date: DateTime.parse('2021-01-01'),
            summary: Faker().lorem.sentences(3).join(' '),
            issuer: 'Issuer 2',
          ),
        ],
        skills: const [
          Skill(
            id: '1',
            name: 'Flutter',
            level: 'Avançado',
          ),
          Skill(
            id: '2',
            name: 'Dart',
            level: 'Expert',
          ),
          Skill(
            id: '3',
            name: 'React',
            level: 'Expert',
          ),
          Skill(
            id: '4',
            name: 'Git',
            level: 'Expert',
          ),
          Skill(
            id: '5',
            name: 'Clean Architecture',
            level: 'Expert',
          ),
          Skill(
            id: '6',
            name: 'CI/CD',
            level: 'Expert',
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
            name: 'Inglês',
            fluency: 'Intermediário',
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
        template: ResumeTemplate.simple,
        createdAt: DateTime.now(),
      );

  Resume copyWith({
    String? id,
    bool? isActive,
    String? resumeName,
    String? name,
    String? profession,
    DateTime? birthDate,
    String? photo,
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
  }) {
    return Resume(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      resumeName: resumeName ?? this.resumeName,
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
    );
  }

  @override
  List<Object?> get props => [
        id,
        isActive,
        resumeName,
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
      ];
}

extension ToPdfExtension on Resume {
  Future<Uint8List> toPdf() async {
    return switch (template) {
      ResumeTemplate.simple => SimpleResumeTemplate.generatePdf(this),
      ResumeTemplate.elegant => SimpleResumeTemplate.generatePdf(this),
      ResumeTemplate.modern => SimpleResumeTemplate.generatePdf(this)
    };
  }
}
