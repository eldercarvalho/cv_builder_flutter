import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../../ui/shared/extensions/datetime.dart';
import '../../models/resume.dart';
import 'constants.dart';
import 'texts.dart';
import 'widgets/persoal_info.dart';
import 'widgets/section_title.dart';
import 'widgets/social_network.dart';

class BasicResumeTemplate {
  static Future<Uint8List> generatePdf(Resume resume) async {
    final pdf = Document();
    final config = await TemplateConfig.instance;
    final texts = getTexts(resume.resumeLanguage!);

    final photo = resume.hasPhoto
        ? resume.isNetworkPhoto
            ? await networkImage(resume.photo!)
            : MemoryImage(await File(resume.photo!).readAsBytes())
        : null;
    final birthdayText =
        resume.birthDate != null ? '${resume.birthDate?.toSimpleDate()} - ${resume.age} ${texts.years}' : null;

    final List<Widget> children = [
      // Cabeçalho
      Row(
        // crossAxisAlignment: CrossAxisAlignment.,
        children: [
          if (photo != null) ...[
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: photo, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 24),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(resume.name, style: config.titleLargeTextStyle),
              if (resume.profession != null) Text(resume.profession!, style: config.bodyLargeTextStyle),
            ],
          ),
        ],
      ),

      SizedBox(height: sectionSpace),

      // Sobre
      PersonalInfo(text: birthdayText, icon: 'cake', marginTop: 0, config: config),
      PersonalInfo(text: resume.formattedAddress, icon: 'mapmarker', config: config),
      PersonalInfo(text: resume.phoneNumber, icon: 'phone', config: config),
      PersonalInfo(text: resume.email, icon: 'email', config: config),
      PersonalInfo(text: resume.website, icon: 'website', config: config),

      // Redes Sociais
      if (resume.socialNetworks.isNotEmpty)
        ListView.builder(
          itemCount: resume.socialNetworks.length,
          itemBuilder: (context, index) {
            final social = resume.socialNetworks[index];
            return SocialNetworkInfo(socialNetwork: social, config: config);
          },
          // separatorBuilder: (context, index) => SizedBox(height: lineSpace),
        ),

      // Objetivo
      if (resume.objectiveSummary != null && resume.objectiveSummary!.isNotEmpty) ...[
        SizedBox(height: sectionSpace),
        SectionTitle(text: texts.objective, config: config),
        SizedBox(height: titleSpace),
        Text(resume.objectiveSummary!, style: config.paragraphTextStyle),
      ],

      // Experiência
      if (resume.workExperience.isNotEmpty) ...[
        SizedBox(height: sectionSpace),
        SectionTitle(text: texts.experience, config: config),
        SizedBox(height: titleSpace),
        ListView.separated(
          itemBuilder: (context, index) {
            final experience = resume.workExperience[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(experience.position, style: config.titleSmallTextStyle),
                SizedBox(height: lineSpace),
                Text(experience.company, style: config.bodyMediumTextStyle),
                SizedBox(height: lineSpace),
                Row(children: [
                  Text(experience.startDate.toShortDate(), style: config.bodyMediumTextStyle),
                  if (experience.endDate != null)
                    Text(' - ${experience.endDate!.toShortDate()}', style: config.bodyMediumTextStyle),
                  if (experience.endDate == null) Text(' - Atual', style: config.bodyMediumTextStyle),
                ]),
                if (experience.summary != null) ...[
                  SizedBox(height: lineSpace),
                  Text(texts.responsibilities, style: config.bodySmallTextStyle),
                  SizedBox(height: lineSpace),
                  Text(experience.summary!, style: config.paragraphTextStyle),
                ],
              ],
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: resume.workExperience.length,
        ),
      ],

      // Habilidades
      if (resume.skills.isNotEmpty) ...[
        SizedBox(height: sectionSpace),
        SectionTitle(text: texts.skills, config: config),
        SizedBox(height: titleSpace),
        ListView.separated(
          itemCount: resume.skills.length,
          itemBuilder: (context, index) {
            final skill = resume.skills[index];
            return Row(
              children: [
                // Icon(IconData(''), size: 10),
                Text(skill.name, style: config.titleSmallTextStyle),
                Text(' - ${skill.level}', style: config.bodyMediumTextStyle),
              ],
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: lineSpace),
        ),
      ],

      // Formação
      if (resume.education.isNotEmpty) ...[
        SizedBox(height: sectionSpace),
        SectionTitle(text: texts.education, config: config),
        SizedBox(height: titleSpace),
        ListView.separated(
          itemBuilder: (context, index) {
            final education = resume.education[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(education.fieldOfStudy, style: config.titleSmallTextStyle),
                SizedBox(height: lineSpace),
                Text(education.institution, style: config.bodyMediumTextStyle),
                SizedBox(height: lineSpace),
                Row(children: [
                  Text(education.startDate.toShortDate(), style: config.bodyMediumTextStyle),
                  if (education.endDate != null)
                    Text('- ${education.endDate!.toShortDate()}', style: config.bodyMediumTextStyle),
                  if (education.endDate == null) Text('- ${texts.current}', style: config.bodyMediumTextStyle),
                ]),
                if (education.summary != null) ...[
                  SizedBox(height: lineSpace),
                  Text(education.summary!, style: config.bodyMediumTextStyle),
                ],
              ],
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: innerSpace),
          itemCount: resume.education.length,
        )
      ],

      // Idiomas
      if (resume.languages.isNotEmpty) ...[
        SizedBox(height: sectionSpace),
        SectionTitle(text: texts.languages, config: config),
        SizedBox(height: titleSpace),
        ListView.separated(
          itemBuilder: (context, index) {
            final language = resume.languages[index];
            return Row(
              children: [
                Text(language.name, style: config.titleSmallTextStyle),
                if (language.fluency != null) Text(' - ${language.fluency}', style: config.bodyMediumTextStyle),
              ],
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: lineSpace),
          itemCount: resume.languages.length,
        )
      ],

      // Certificações
      if (resume.certifications.isNotEmpty) ...[
        SizedBox(height: sectionSpace),
        SectionTitle(text: texts.certifications, config: config),
        SizedBox(height: titleSpace),
        ListView.separated(
          itemBuilder: (context, index) {
            final certification = resume.certifications[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(certification.title, style: config.titleSmallTextStyle),
                Text(certification.issuer, style: config.bodyMediumTextStyle),
                Text(certification.date.toShortDate(), style: config.bodyMediumTextStyle),
                if (certification.summary != null) ...[
                  SizedBox(height: lineSpace),
                  Text(certification.summary!, style: config.paragraphTextStyle),
                ],
              ],
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: lineSpace),
          itemCount: resume.certifications.length,
        )
      ],

      // Projetos
      if (resume.projects.isNotEmpty) ...[
        SizedBox(height: sectionSpace),
        SectionTitle(text: texts.projects, config: config),
        SizedBox(height: titleSpace),
        ListView.separated(
          itemCount: resume.projects.length,
          itemBuilder: (context, index) {
            final project = resume.projects[index];
            return Column(children: [
              Row(
                children: [
                  Text(project.title, style: config.titleSmallTextStyle),
                  if (project.startDate != null)
                    Text(' - ${project.startDate!.toShortDate()}', style: config.bodyMediumTextStyle),
                  if (project.endDate != null)
                    Text(' - ${project.endDate!.toShortDate()}', style: config.bodyMediumTextStyle),
                ],
              ),
              if (project.summary != null) ...[
                SizedBox(height: lineSpace),
                Text(project.summary!, style: config.paragraphTextStyle),
              ],
            ]);
          },
          separatorBuilder: (context, index) => SizedBox(height: innerSpace),
        ),
      ],

      if (resume.references.isNotEmpty) ...[
        SizedBox(height: sectionSpace),
        SectionTitle(text: texts.references, config: config),
        SizedBox(height: titleSpace),
        ListView.separated(
          itemCount: resume.references.length,
          itemBuilder: (context, index) {
            final reference = resume.references[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(reference.name, style: config.titleSmallTextStyle),
                SizedBox(height: lineSpace),
                Text(reference.position, style: config.bodyMediumTextStyle),
                SizedBox(height: lineSpace),
                Text(reference.phoneNumber, style: config.bodyMediumTextStyle),
                if (reference.email != null) ...[
                  SizedBox(height: lineSpace),
                  Text(reference.email!, style: config.bodyMediumTextStyle),
                ],
                if (reference.summary != null) ...[
                  SizedBox(height: lineSpace),
                  Text(reference.summary!, style: config.paragraphTextStyle),
                ],
              ],
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: innerSpace),
        ),
      ],

      // Hobbies
      if (resume.hobbies.isNotEmpty) ...[
        SizedBox(height: sectionSpace),
        SectionTitle(text: texts.hobbies, config: config),
        SizedBox(height: titleSpace),
        ListView.separated(
          itemCount: resume.hobbies.length,
          itemBuilder: (context, index) {
            final hobbie = resume.hobbies[index];
            return Text(hobbie.name, style: config.bodyMediumTextStyle);
          },
          separatorBuilder: (context, index) => SizedBox(height: lineSpace),
        ),
      ],
    ];

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const EdgeInsets.all(margin),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        build: (context) => children,
      ),
    );

    return pdf.save();
  }

  static Future<Uint8List> generateThumbnail(Resume resume) async {
    late PdfRaster raster;
    final pdfBytes = await generatePdf(resume);

    await for (final image in Printing.raster(pdfBytes, pages: const [0])) {
      raster = image;
    }
    return raster.toPng();
  }

  static TemplateTexts getTexts(ResumeLanguage language) {
    return switch (language) {
      ResumeLanguage.pt => TemplateTexts(
          years: 'anos',
          contact: 'Contato',
          objective: 'Objetivo',
          experience: 'Experiência',
          skills: 'Habilidades',
          education: 'Educação',
          languages: 'Idiomas',
          certifications: 'Certificações',
          projects: 'Projetos',
          references: 'Referências',
          hobbies: 'Interesses',
          responsibilities: 'Responsabilidades',
          current: 'Atual',
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
          responsibilities: 'Responsibilities',
          current: 'Current',
        ),
    };
  }
}
