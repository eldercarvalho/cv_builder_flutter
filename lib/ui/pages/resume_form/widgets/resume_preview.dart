import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../shared/extensions/extensions.dart';

class ResumePreview extends StatelessWidget {
  const ResumePreview({super.key, required this.pdfFile});

  final File pdfFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.resumePreview),
      ),
      body: SfPdfViewer.file(pdfFile),
    );
  }
}
