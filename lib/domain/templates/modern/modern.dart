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
import 'widgets/widgets.dart';

class ModernTemplate {
  static Future<Uint8List> generatePdf(Resume resume) async {
    // try {
    final pdf = Document();
    final pageWidth = PdfPageFormat.a4.width;
    final pageHeight = PdfPageFormat.a4.height;
    final leftColumnWidth = pageWidth * 0.35;
    final rightColumnWidth = pageWidth * 0.65;
    final config = await TemplateConfig.instance;
    final resumeLanguage = resume.resumeLanguage!.name;
    final texts = getTexts(resume.resumeLanguage!);

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
              // flex: 1,
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

                  // Formação
                  if (resume.education.isNotEmpty) ...[
                    SectionTitle(text: texts.education, config: config),
                    SizedBox(height: config.titleSpace),
                    ListView.separated(
                      itemBuilder: (context, index) {
                        final education = resume.education[index];
                        return Box(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(education.fieldOfStudy, style: config.titleSmallTextStyle),
                              SizedBox(height: config.lineSpace),
                              Text(education.institution, style: config.bodyMediumTextStyle),
                              SizedBox(height: config.lineSpace),
                              Row(children: [
                                Text(education.startDate.toShortDate(locale: resumeLanguage),
                                    style: config.bodyMediumTextStyle),
                                if (education.endDate != null)
                                  Text('- ${education.endDate!.toShortDate(locale: resumeLanguage)}',
                                      style: config.bodyMediumTextStyle),
                                if (education.endDate == null)
                                  Text('- ${texts.current}', style: config.bodyMediumTextStyle),
                              ]),
                              if (education.summary != null) ...[
                                SizedBox(height: config.lineSpace),
                                Text(education.summary!, style: config.bodyMediumTextStyle),
                              ],
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: config.innerSpace),
                      itemCount: resume.education.length,
                    )
                  ],

                  // Habilidades
                  if (resume.skills.isNotEmpty) ...[
                    SizedBox(height: config.sectionSpace),
                    SectionTitle(text: texts.skills, config: config),
                    SizedBox(height: config.titleSpace),
                    ...List.generate(
                      resume.skills.length,
                      (index) {
                        final skill = resume.skills[index];
                        return Bullet(
                          text:
                              skill.name + (skill.level != null && skill.level!.isNotEmpty ? ' - ${skill.level}' : ''),
                          style: config.bodyMediumTextStyle,
                        );
                      },
                    )
                  ],

                  // Idiomas
                  if (resume.languages.isNotEmpty) ...[
                    SizedBox(height: config.sectionSpace),
                    SectionTitle(text: texts.languages, config: config),
                    SizedBox(height: config.titleSpace),
                    ...List.generate(resume.languages.length, (index) {
                      final language = resume.languages[index];
                      return Bullet(
                        text: language.name +
                            (language.fluency != null && language.fluency!.isNotEmpty ? ' - ${language.fluency}' : ''),
                        style: config.bodyMediumTextStyle,
                      );
                    })
                    // ListView.separated(
                    //   itemBuilder: (context, index) {
                    //     final language = resume.languages[index];
                    //     return Box(
                    //       child: Row(
                    //         children: [
                    //           Text(language.name, style: config.titleXSmallTextStyle),
                    //           if (language.fluency != null && language.fluency!.isNotEmpty)
                    //             Text(' - ${language.fluency}', style: config.bodyMediumTextStyle),
                    //         ],
                    //       ),
                    //     );
                    //   },
                    //   separatorBuilder: (context, index) => SizedBox(height: config.lineSpace),
                    //   itemCount: resume.languages.length,
                    // )
                  ],

                  // Certificações
                  if (resume.certifications.isNotEmpty) ...[
                    SizedBox(height: config.sectionSpace),
                    SectionTitle(text: texts.certifications, config: config),
                    SizedBox(height: config.titleSpace),
                    ...List.generate(
                      resume.certifications.length,
                      (index) {
                        final certification = resume.certifications[index];
                        return Box(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(certification.title, style: config.titleSmallTextStyle),
                              Text(certification.issuer, style: config.bodyMediumTextStyle),
                              Text(certification.date.toShortDate(locale: resume.resumeLanguage!.name),
                                  style: config.bodyMediumTextStyle),
                              if (certification.summary != null) ...[
                                SizedBox(height: config.lineSpace),
                                Text(certification.summary!, style: config.paragraphTextStyle),
                              ],
                              if (index < resume.certifications.length - 1) SizedBox(height: config.innerSpace),
                            ],
                          ),
                        );
                      },
                    )
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
                        Text(resume.name, style: config.titleLargeTextStyle),
                        if (resume.profession != null) Text(resume.profession!, style: config.bodyLargeTextStyle),
                      ],
                    ),
                  ),

                  SizedBox(height: config.sectionSpace),

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
                  if (resume.socialNetworks.isNotEmpty)
                    Box(
                      child: ListView.builder(
                        itemCount: resume.socialNetworks.length,
                        itemBuilder: (context, index) {
                          final social = resume.socialNetworks[index];
                          return SocialNetworkInfo(socialNetwork: social, config: config);
                        },
                        // separatorBuilder: (context, index) => SizedBox(height: config.lineSpace),
                      ),
                    ),

                  // Objetivo
                  if (resume.objectiveSummary != null && resume.objectiveSummary!.isNotEmpty) ...[
                    SizedBox(height: config.sectionSpace),
                    SectionTitle(text: texts.objective, config: config),
                    SizedBox(height: config.titleSpace),
                    Box(child: Text(resume.objectiveSummary!, style: config.paragraphTextStyle))
                  ],

                  // Experiência
                  if (resume.workExperience.isNotEmpty) ...[
                    SizedBox(height: config.sectionSpace),
                    SectionTitle(text: texts.experience, config: config),
                    SizedBox(height: config.titleSpace),
                    ...List.generate(
                      resume.workExperience.length,
                      (index) {
                        final experience = resume.workExperience[index];
                        return Box(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(experience.position, style: config.titleSmallTextStyle),
                              SizedBox(height: config.lineSpace),
                              Row(
                                children: [
                                  Text(experience.company, style: config.bodyMediumTextStyle),
                                  if (experience.website.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: UrlLink(
                                        child:
                                            SvgImage(svg: getIconSvg('link'), colorFilter: PdfColors.blue, width: 12),
                                        destination: experience.website,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: config.lineSpace),
                              Row(children: [
                                Text(experience.startDate.toShortDate(locale: resumeLanguage),
                                    style: config.bodyMediumTextStyle),
                                if (experience.endDate != null)
                                  Text(' - ${experience.endDate!.toShortDate(locale: resumeLanguage)}',
                                      style: config.bodyMediumTextStyle),
                                if (experience.endDate == null)
                                  Text(' - ${texts.current}', style: config.bodyMediumTextStyle),
                              ]),
                              if (experience.summary != null && experience.summary!.isNotEmpty) ...[
                                SizedBox(height: config.lineSpace),
                                Text(texts.responsibilities, style: config.bodySmallTextStyle),
                                SizedBox(height: config.lineSpace),
                                Text(experience.summary!, style: config.paragraphTextStyle),
                              ],
                              if (index < resume.workExperience.length - 1) SizedBox(height: config.innerSpace),
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
            return Container(
              color: PdfColor.fromHex('#D8DFE7'),
              width: pageWidth * 0.35,
              height: pageHeight,
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
