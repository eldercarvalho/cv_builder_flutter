import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ResumePreview extends StatelessWidget {
  const ResumePreview({super.key, required this.pdfFile});

  final File pdfFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pré-visualização'),
      ),
      body: SfPdfViewer.file(pdfFile),
    );
  }
}
