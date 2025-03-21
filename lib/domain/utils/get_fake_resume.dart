import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';

import '../models/award.dart';
import '../models/certification.dart';
import '../models/education.dart';
import '../models/hobbie.dart';
import '../models/language.dart';
import '../models/project.dart';
import '../models/reference.dart';
import '../models/resume.dart';
import '../models/skill.dart';
import '../models/social_network.dart';
import '../models/work_experience.dart';


Resume createFakeResume() => Resume(
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
