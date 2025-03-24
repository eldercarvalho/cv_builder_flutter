import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../models/resume.dart';
import '../template_config.dart';
import 'widgets/widgets.dart';

class BasicTemplate {
  static Future<Uint8List> generatePdf(Resume resume) async {
    // try {
    final pdf = Document();
    final config = await TemplateConfig.getInstance(theme: resume.theme);
    final colors = resume.theme.primaryColors;

    final photo = resume.hasPhoto
        ? resume.isNetworkPhoto
            ? await networkImage(resume.photo!)
            : MemoryImage(await File(resume.photo!).readAsBytes())
        : null;

    final List<Widget> children = [
      HeaderSection(photo: photo, resume: resume, config: config),
      SizedBox(height: config.sectionSpace),

      for (final section in resume.sections) ...[
        ...buildSection(resume: resume, section: section, config: config),
        if (section != resume.sections.last) SizedBox(height: config.sectionSpace),
      ],

      //   // Projetos
      //   if (resume.projects.isNotEmpty) ...[
      //     SizedBox(height: config.sectionSpace),
      //     SectionTitle(text: texts.projects, config: config),
      //     SizedBox(height: config.titleSpace),
      //     ListView.separated(
      //       itemCount: resume.projects.length,
      //       itemBuilder: (context, index) {
      //         final project = resume.projects[index];
      //         return Column(children: [
      //           Row(
      //             children: [
      //               Text(project.title, style: config.titleSmallTextStyle),
      //               if (project.startDate != null)
      //                 Text(' - ${project.startDate!.toShortDate(locale: resumeLanguage)}',
      //                     style: config.bodyMediumTextStyle),
      //               if (project.endDate != null)
      //                 Text(' - ${project.endDate!.toShortDate(locale: resumeLanguage)}',
      //                     style: config.bodyMediumTextStyle),
      //             ],
      //           ),
      //           if (project.summary != null) ...[
      //             SizedBox(height: config.lineSpace),
      //             Text(project.summary!, style: config.paragraphTextStyle),
      //           ],
      //         ]);
      //       },
      //       separatorBuilder: (context, index) => SizedBox(height: config.innerSpace),
      //     ),
      //   ],

      //   if (resume.references.isNotEmpty) ...[
      //     SizedBox(height: config.sectionSpace),
      //     SectionTitle(text: texts.references, config: config),
      //     SizedBox(height: config.titleSpace),
      //     ListView.separated(
      //       itemCount: resume.references.length,
      //       itemBuilder: (context, index) {
      //         final reference = resume.references[index];
      //         return Column(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: [
      //             Text(reference.name, style: config.titleSmallTextStyle),
      //             SizedBox(height: config.lineSpace),
      //             Text(reference.position, style: config.bodyMediumTextStyle),
      //             SizedBox(height: config.lineSpace),
      //             Text(reference.phoneNumber, style: config.bodyMediumTextStyle),
      //             if (reference.email != null) ...[
      //               SizedBox(height: config.lineSpace),
      //               Text(reference.email!, style: config.bodyMediumTextStyle),
      //             ],
      //             if (reference.summary != null) ...[
      //               SizedBox(height: config.lineSpace),
      //               Text(reference.summary!, style: config.paragraphTextStyle),
      //             ],
      //           ],
      //         );
      //       },
      //       separatorBuilder: (context, index) => SizedBox(height: config.innerSpace),
      //     ),
      //   ],

      //   // Hobbies
      //   if (resume.hobbies.isNotEmpty) ...[
      //     SizedBox(height: config.sectionSpace),
      //     SectionTitle(text: texts.hobbies, config: config),
      //     SizedBox(height: config.titleSpace),
      //     ListView.separated(
      //       itemCount: resume.hobbies.length,
      //       itemBuilder: (context, index) {
      //         final hobbie = resume.hobbies[index];
      //         return Text(hobbie.name, style: config.bodyMediumTextStyle);
      //       },
      //       separatorBuilder: (context, index) => SizedBox(height: config.lineSpace),
      //     ),
      //   ],
    ];

    pdf.addPage(
      MultiPage(
        build: (context) => [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: config.horizontalMargin, vertical: config.verticalMargin),
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
