import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../models/resume.dart';
import '../constants.dart';
import '../template_config.dart';
import 'widgets/widgets.dart';

class ModernTemplate {
  static Future<Uint8List> generatePdf(Resume resume) async {
    // try {
    final pdf = Document();
    final pageWidth = PdfPageFormat.a4.width;
    final pageHeight = PdfPageFormat.a4.height;
    final leftColumnWidth = pageWidth * 0.35;
    final rightColumnWidth = pageWidth * 0.65;
    final config = await TemplateConfig.getInstance(
      theme: resume.theme,
      font: TemplateFont.cabin,
      horizontalMargin: 0,
      verticalMargin: 0,
    );
    final primaryColors = config.theme.primaryColors;
    final secondaryColors = config.theme.secondaryColors;

    final photo = resume.hasPhoto
        ? resume.isNetworkPhoto
            ? await networkImage(resume.photo!)
            : MemoryImage(await File(resume.photo!).readAsBytes())
        : null;

    final firstColumnSections = resume.sections
        .take(4)
        .map((section) => buildSection(
              resume: resume,
              section: section,
              config: config,
              column: TemplateColumn.one,
            ))
        .toList();

    final secondColumnSections = resume.sections
        .skip(4)
        .map((section) => buildSection(
              resume: resume,
              section: section,
              config: config,
              column: TemplateColumn.two,
            ))
        .toList();

    final List<Widget> children = [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Partitions(
          children: [
            Partition(
              width: leftColumnWidth,
              child: Column(
                children: [
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
                  for (final (index, section) in firstColumnSections.indexed) ...[
                    ...section,
                    if (index < firstColumnSections.length - 1 && section.isNotEmpty)
                      SizedBox(height: config.sectionSpace),
                  ]
                ],
              ),
            ),
            Partition(
              width: rightColumnWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(resume: resume, config: config),
                  for (final (index, section) in secondColumnSections.indexed) ...[
                    ...section,
                    if (index < secondColumnSections.length - 1 && section.isNotEmpty)
                      SizedBox(height: config.sectionSpace),
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
