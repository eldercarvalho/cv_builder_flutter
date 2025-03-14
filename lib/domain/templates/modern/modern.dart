import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../../ui/shared/extensions/datetime.dart';
import '../../models/resume.dart';
import '../constants.dart';
import '../icons.dart';
import '../texts.dart';
import 'constants.dart';
import 'widgets/widgets.dart';

class ModernTemplate {
  static Future<Uint8List> generatePdf(Resume resume) async {
    // try {
    final pdf = Document();
    final pageWidth = PdfPageFormat.a4.width;
    final pageHeight = PdfPageFormat.a4.height;
    final leftColumnWidth = pageWidth * 0.35;
    final rightColumnWidth = pageWidth * 0.65;
    final resumeLanguage = resume.resumeLanguage!.name;
    final texts = getTexts(resume.resumeLanguage!);
    final config = await TemplateConfig.getInstance(resume.theme);
    final primaryColors = config.theme.primaryColors;
    final secondaryColors = config.theme.secondaryColors;

    final photo = resume.hasPhoto
        ? resume.isNetworkPhoto
            ? await networkImage(resume.photo!)
            : MemoryImage(await File(resume.photo!).readAsBytes())
        : null;
    final birthdayText =
        resume.birthDate != null ? '${resume.birthDate?.toSimpleDate()} - ${resume.age} ${texts.years}' : null;

    final List<Widget> children = [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Partitions(
          children: [
            Partition(
              width: leftColumnWidth,
              child: Column(
                children: [
                  // Photo
                  if (photo != null) ...[
                    Container(
                      width: pageWidth * 0.35 - 42,
                      height: pageWidth * 0.35 - 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: photo, fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(height: config.sectionSpace),
                  ],

                  SectionTitle(text: texts.contact, config: config, column: TemplateColumn.one),
                  SizedBox(height: config.titleSpace),

                  // Sobre
                  Box(
                    child: Column(children: [
                      PersonalInfo(text: birthdayText, icon: 'cake', marginTop: 0, config: config),
                      PersonalInfo(text: resume.formattedAddress, icon: 'mapmarker', config: config),
                      PersonalInfo(text: resume.phoneNumber, icon: 'phone', config: config),
                      PersonalInfo(text: resume.email, icon: 'email', config: config),
                      PersonalInfo(text: resume.website, icon: 'website', config: config),
                    ]),
                  ),

                  // Redes Sociais
                  if (resume.socialNetworks.isNotEmpty) ...[
                    Box(
                      child: ListView.builder(
                        itemCount: resume.socialNetworks.length,
                        itemBuilder: (context, index) {
                          final social = resume.socialNetworks[index];
                          return SocialNetworkInfo(socialNetwork: social, config: config);
                        },
                        // separatorBuilder: (context, index) => SizedBox(height: config.lineSpace),
                      ),
                    )
                  ],

                  // Formação
                  if (resume.education.isNotEmpty) ...[
                    SizedBox(height: config.sectionSpace),
                    SectionTitle(text: texts.education, config: config, column: TemplateColumn.one),
                    SizedBox(height: config.titleSpace),
                    ...List.generate(
                      resume.education.length,
                      (index) {
                        final education = resume.education[index];
                        return Box(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(education.fieldOfStudy, style: config.titleSmallTextStyle1),
                              SizedBox(height: config.lineSpace),
                              Text(education.institution, style: config.bodyMediumTextStyle1),
                              SizedBox(height: config.lineSpace),
                              Row(children: [
                                Text(education.startDate.toShortDate(locale: resumeLanguage),
                                    style: config.bodyMediumTextStyle1),
                                if (education.endDate != null)
                                  Text('- ${education.endDate!.toShortDate(locale: resumeLanguage)}',
                                      style: config.bodyMediumTextStyle1),
                                if (education.endDate == null)
                                  Text('- ${texts.current}', style: config.bodyMediumTextStyle1),
                              ]),
                              if (education.summary != null) ...[
                                SizedBox(height: config.lineSpace),
                                Text(education.summary!, style: config.bodyMediumTextStyle1),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    if (resume.skills.isNotEmpty) SizedBox(height: config.sectionSpace),
                  ],

                  // Habilidades
                  if (resume.skills.isNotEmpty) ...[
                    SectionTitle(text: texts.skills, config: config, column: TemplateColumn.one),
                    SizedBox(height: config.titleSpace),
                    ...List.generate(
                      resume.skills.length,
                      (index) {
                        final skill = resume.skills[index];
                        return Bullet(
                          text:
                              skill.name + (skill.level != null && skill.level!.isNotEmpty ? ' - ${skill.level}' : ''),
                          style: config.bodyMediumTextStyle1.copyWith(lineSpacing: 1),
                          bulletColor: PdfColor.fromHex(primaryColors.textColor),
                          padding: const EdgeInsets.only(left: 6, right: 16),
                        );
                      },
                    ),
                    if (resume.languages.isNotEmpty) SizedBox(height: config.sectionSpace),
                  ],

                  // Idiomas
                  if (resume.languages.isNotEmpty) ...[
                    SectionTitle(text: texts.languages, config: config, column: TemplateColumn.one),
                    SizedBox(height: config.titleSpace),
                    ...List.generate(resume.languages.length, (index) {
                      final language = resume.languages[index];
                      return Bullet(
                        text: language.name +
                            (language.fluency != null && language.fluency!.isNotEmpty ? ' - ${language.fluency}' : ''),
                        style: config.bodyMediumTextStyle1.copyWith(lineSpacing: 1),
                        bulletColor: PdfColor.fromHex(primaryColors.textColor),
                        padding: const EdgeInsets.only(left: 6, right: 16),
                      );
                    })
                  ],
                ],
              ),
            ),
            Partition(
              // flex: 2,
              width: rightColumnWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Box(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(resume.name, style: config.titleLargeTextStyle2),
                        if (resume.profession != null) Text(resume.profession!, style: config.bodyLargeTextStyle2),
                        SizedBox(height: config.sectionSpace),
                      ],
                    ),
                  ),

                  // Objetivo
                  if (resume.objectiveSummary != null && resume.objectiveSummary!.isNotEmpty) ...[
                    SectionTitle(text: texts.objective, config: config, column: TemplateColumn.two),
                    SizedBox(height: config.titleSpace),
                    Box(child: Text(resume.objectiveSummary!, style: config.paragraphTextStyle2)),
                    SizedBox(height: config.sectionSpace),
                  ],

                  // Experiência
                  if (resume.workExperience.isNotEmpty) ...[
                    SectionTitle(text: texts.experience, config: config, column: TemplateColumn.two),
                    SizedBox(height: config.titleSpace),
                    ...List.generate(
                      resume.workExperience.length,
                      (index) {
                        final experience = resume.workExperience[index];
                        return Box(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(experience.position, style: config.titleSmallTextStyle2),
                              SizedBox(height: config.lineSpace),
                              Row(
                                children: [
                                  Text(experience.company, style: config.bodyMediumTextStyle2),
                                  if (experience.website.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: UrlLink(
                                        child: SvgImage(
                                          svg: getIconSvg('link'),
                                          colorFilter: PdfColor.fromHex(secondaryColors.linkColor),
                                          width: 12,
                                        ),
                                        destination: experience.website,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: config.lineSpace),
                              Row(children: [
                                Text(experience.startDate.toShortDate(locale: resumeLanguage),
                                    style: config.bodyMediumTextStyle2),
                                if (experience.endDate != null)
                                  Text(' - ${experience.endDate!.toShortDate(locale: resumeLanguage)}',
                                      style: config.bodyMediumTextStyle2),
                                if (experience.endDate == null)
                                  Text(' - ${texts.current}', style: config.bodyMediumTextStyle2),
                              ]),
                              if (experience.summary != null && experience.summary!.isNotEmpty) ...[
                                SizedBox(height: config.lineSpace),
                                Text(texts.responsibilities, style: config.bodySmallTextStyle2),
                                SizedBox(height: config.lineSpace),
                                Text(experience.summary!, style: config.paragraphTextStyle2),
                              ],
                              if (index < resume.workExperience.length - 1) SizedBox(height: config.innerSpace),
                            ],
                          ),
                        );
                      },
                    ),
                    if (resume.certifications.isNotEmpty) SizedBox(height: config.sectionSpace),
                  ],

                  // Certificações
                  if (resume.certifications.isNotEmpty) ...[
                    SectionTitle(text: texts.certifications, config: config, column: TemplateColumn.two),
                    SizedBox(height: config.titleSpace),
                    ...List.generate(
                      resume.certifications.length,
                      (index) {
                        final certification = resume.certifications[index];
                        return Box(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(certification.title, style: config.titleSmallTextStyle2),
                              Text(certification.issuer, style: config.bodyMediumTextStyle2),
                              if (certification.date != null)
                                Text(certification.date!.toShortDate(locale: resume.resumeLanguage!.name),
                                    style: config.bodyMediumTextStyle2),
                              if (certification.summary != null) ...[
                                SizedBox(height: config.lineSpace),
                                Text(certification.summary!, style: config.paragraphTextStyle2),
                              ],
                              if (index < resume.certifications.length - 1) SizedBox(height: config.innerSpace),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ];

    pdf.addPage(
      MultiPage(
        build: (context) => children,
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: EdgeInsets.zero,
          buildBackground: (context) {
            return Row(
              children: [
                Container(
                  width: pageWidth * 0.35,
                  height: pageHeight,
                  color: PdfColor.fromHex(primaryColors.backgroundColor),
                ),
                Container(
                  width: pageWidth * 0.65,
                  height: pageHeight,
                  color: PdfColor.fromHex(secondaryColors.backgroundColor),
                ),
              ],
            );
          },
        ),
      ),
    );

    return pdf.save();
    // } catch (e) {
    //   throw Exception(e.toString());
    // }
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
