import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../../ui/shared/extensions/datetime.dart';
import '../../models/resume.dart';
import '../icons.dart';
import '../texts.dart';
import 'constants.dart';
import 'widgets/persoal_info.dart';
import 'widgets/section_title.dart';
import 'widgets/social_network.dart';

class BasicTemplate {
  static Future<Uint8List> generatePdf(Resume resume) async {
    try {
      final pdf = Document();
      final pageWidth = PdfPageFormat.a4.availableWidth;
      final config = await TemplateConfig.getInstance(resume.theme);
      final resumeLanguage = resume.resumeLanguage!.name;
      final texts = getTexts(resume.resumeLanguage!);
      final colors = resume.theme.primaryColors;

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
                width: config.imageSize,
                height: config.imageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: photo, fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 24),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(resume.name, style: config.titleLargeTextStyle),
                  if (resume.profession != null) Text(resume.profession!, style: config.bodyLargeTextStyle),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: config.sectionSpace),

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
            // separatorBuilder: (context, index) => SizedBox(height: config.lineSpace),
          ),

        // Objetivo
        if (resume.objectiveSummary != null && resume.objectiveSummary!.isNotEmpty) ...[
          SizedBox(height: config.sectionSpace),
          SectionTitle(text: texts.objective, config: config),
          SizedBox(height: config.titleSpace),
          Text(resume.objectiveSummary!, style: config.paragraphTextStyle),
          SizedBox(height: config.sectionSpace),
        ],

        // Experiência
        if (resume.workExperience.isNotEmpty) ...[
          SectionTitle(text: texts.experience, config: config),
          SizedBox(height: config.titleSpace),
          ...List.generate(
            resume.workExperience.length,
            (index) {
              final experience = resume.workExperience[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    Expanded(child: Text(experience.position, style: config.titleSmallTextStyle)),
                    Text(experience.startDate.toShortDate(locale: resumeLanguage), style: config.bodyMediumTextStyle),
                    if (experience.endDate != null)
                      Text(' - ${experience.endDate!.toShortDate(locale: resumeLanguage)}',
                          style: config.bodyMediumTextStyle),
                    if (experience.endDate == null) Text(' - ${texts.current}', style: config.bodyMediumTextStyle),
                  ]),
                  SizedBox(height: config.lineSpace),
                  Row(
                    children: [
                      Text(experience.company, style: config.bodyMediumTextStyle),
                      if (experience.website.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: UrlLink(
                            child: SvgImage(
                              svg: getIconSvg('link'),
                              colorFilter: PdfColor.fromHex(colors.linkColor),
                              width: 12,
                            ),
                            destination: experience.website,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: config.lineSpace),
                  if (experience.summary != null && experience.summary!.isNotEmpty) ...[
                    SizedBox(height: config.lineSpace),
                    Text(texts.responsibilities, style: config.bodySmallTextStyle),
                    SizedBox(height: config.lineSpace),
                    Text(experience.summary!, style: config.paragraphTextStyle),
                  ],
                  if (index < resume.workExperience.length - 1) SizedBox(height: config.innerSpace),
                ],
              );
            },
          ),
          if (resume.skills.isNotEmpty) SizedBox(height: config.sectionSpace),
        ],

        // Habilidades
        if (resume.skills.isNotEmpty) ...[
          SectionTitle(text: texts.skills, config: config),
          SizedBox(height: config.titleSpace),
          Wrap(
            children: List.generate(
              resume.skills.length,
              (index) {
                final skill = resume.skills[index];
                return Container(
                  width: (pageWidth / 4) - 10,
                  padding: EdgeInsets.only(top: config.titleSpace, left: index % 4 == 0 ? 0 : 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon(IconData(''), size: 10),
                      Text(skill.name, style: config.titleXSmallTextStyle),
                      if (skill.level != null && skill.level!.isNotEmpty)
                        Text('${skill.level}', style: config.bodySmallTextStyle),
                    ],
                  ),
                );
              },
            ),
          ),
          if (resume.education.isNotEmpty) SizedBox(height: config.sectionSpace),
        ],

        // Formação
        if (resume.education.isNotEmpty) ...[
          SectionTitle(text: texts.education, config: config),
          SizedBox(height: config.titleSpace),
          ListView.separated(
            itemBuilder: (context, index) {
              final education = resume.education[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(education.fieldOfStudy, style: config.titleSmallTextStyle),
                  SizedBox(height: config.lineSpace),
                  Text(education.institution, style: config.bodyMediumTextStyle),
                  SizedBox(height: config.lineSpace),
                  Row(children: [
                    Text(education.startDate.toShortDate(locale: resumeLanguage), style: config.bodyMediumTextStyle),
                    if (education.endDate != null)
                      Text('- ${education.endDate!.toShortDate(locale: resumeLanguage)}',
                          style: config.bodyMediumTextStyle),
                    if (education.endDate == null) Text('- ${texts.current}', style: config.bodyMediumTextStyle),
                  ]),
                  if (education.summary != null) ...[
                    SizedBox(height: config.lineSpace),
                    Text(education.summary!, style: config.bodyMediumTextStyle),
                  ],
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: config.innerSpace),
            itemCount: resume.education.length,
          ),
          if (resume.languages.isNotEmpty) SizedBox(height: config.sectionSpace),
        ],

        // Idiomas
        if (resume.languages.isNotEmpty) ...[
          SectionTitle(text: texts.languages, config: config),
          SizedBox(height: config.titleSpace),
          ...List.generate(resume.languages.length, (index) {
            final language = resume.languages[index];
            return Row(
              children: [
                Text(language.name, style: config.titleXSmallTextStyle),
                if (language.fluency != null && language.fluency!.isNotEmpty)
                  Text(' - ${language.fluency}', style: config.bodyMediumTextStyle),
              ],
            );
          }),
          if (resume.certifications.isNotEmpty) SizedBox(height: config.sectionSpace),
        ],

        // Certificações
        if (resume.certifications.isNotEmpty) ...[
          SectionTitle(text: texts.certifications, config: config),
          SizedBox(height: config.titleSpace),
          ...List.generate(resume.certifications.length, (index) {
            final certification = resume.certifications[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(certification.title, style: config.titleSmallTextStyle),
                Text(certification.issuer, style: config.bodyMediumTextStyle),
                if (certification.date != null)
                  Text(certification.date!.toShortDate(locale: resume.resumeLanguage!.name),
                      style: config.bodyMediumTextStyle),
                if (certification.summary != null) ...[
                  SizedBox(height: config.lineSpace),
                  Text(certification.summary!, style: config.paragraphTextStyle),
                ],
              ],
            );
          })
        ],

        // Projetos
        if (resume.projects.isNotEmpty) ...[
          SizedBox(height: config.sectionSpace),
          SectionTitle(text: texts.projects, config: config),
          SizedBox(height: config.titleSpace),
          ListView.separated(
            itemCount: resume.projects.length,
            itemBuilder: (context, index) {
              final project = resume.projects[index];
              return Column(children: [
                Row(
                  children: [
                    Text(project.title, style: config.titleSmallTextStyle),
                    if (project.startDate != null)
                      Text(' - ${project.startDate!.toShortDate(locale: resumeLanguage)}',
                          style: config.bodyMediumTextStyle),
                    if (project.endDate != null)
                      Text(' - ${project.endDate!.toShortDate(locale: resumeLanguage)}',
                          style: config.bodyMediumTextStyle),
                  ],
                ),
                if (project.summary != null) ...[
                  SizedBox(height: config.lineSpace),
                  Text(project.summary!, style: config.paragraphTextStyle),
                ],
              ]);
            },
            separatorBuilder: (context, index) => SizedBox(height: config.innerSpace),
          ),
        ],

        if (resume.references.isNotEmpty) ...[
          SizedBox(height: config.sectionSpace),
          SectionTitle(text: texts.references, config: config),
          SizedBox(height: config.titleSpace),
          ListView.separated(
            itemCount: resume.references.length,
            itemBuilder: (context, index) {
              final reference = resume.references[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(reference.name, style: config.titleSmallTextStyle),
                  SizedBox(height: config.lineSpace),
                  Text(reference.position, style: config.bodyMediumTextStyle),
                  SizedBox(height: config.lineSpace),
                  Text(reference.phoneNumber, style: config.bodyMediumTextStyle),
                  if (reference.email != null) ...[
                    SizedBox(height: config.lineSpace),
                    Text(reference.email!, style: config.bodyMediumTextStyle),
                  ],
                  if (reference.summary != null) ...[
                    SizedBox(height: config.lineSpace),
                    Text(reference.summary!, style: config.paragraphTextStyle),
                  ],
                ],
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: config.innerSpace),
          ),
        ],

        // Hobbies
        if (resume.hobbies.isNotEmpty) ...[
          SizedBox(height: config.sectionSpace),
          SectionTitle(text: texts.hobbies, config: config),
          SizedBox(height: config.titleSpace),
          ListView.separated(
            itemCount: resume.hobbies.length,
            itemBuilder: (context, index) {
              final hobbie = resume.hobbies[index];
              return Text(hobbie.name, style: config.bodyMediumTextStyle);
            },
            separatorBuilder: (context, index) => SizedBox(height: config.lineSpace),
          ),
        ],
      ];

      pdf.addPage(
        MultiPage(
          build: (context) => [
            Padding(
              padding: EdgeInsets.all(config.horizontalMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            )
          ],
          pageTheme: PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: EdgeInsets.zero,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            buildBackground: (context) => Container(
              color: PdfColor.fromHex(colors.backgroundColor),
            ),
          ),
        ),
      );

      return pdf.save();
    } catch (e) {
      throw Exception('Error generating pdf');
    }
  }

  static Future<Uint8List> generateThumbnail(Resume resume) async {
    late PdfRaster raster;
    final pdfBytes = await generatePdf(resume);

    await for (final image in Printing.raster(pdfBytes, pages: const [0])) {
      raster = image;
    }
    return raster.toPng();
  }
}
