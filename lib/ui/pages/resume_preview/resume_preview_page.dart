import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'view_model/resume_preview_view_model.dart';

class ResumePreviewPage extends StatefulWidget {
  const ResumePreviewPage({super.key, required this.viewModel});

  final ResumePreviewViewModel viewModel;

  static const route = '/home/resume-preview';
  static const path = 'resume-preview/:resumeId';

  static Future<void> push(BuildContext context, {required String resumeId}) async {
    await context.push('$route/$resumeId');
  }

  @override
  State<ResumePreviewPage> createState() => _ResumePreviewPageState();
}

class _ResumePreviewPageState extends State<ResumePreviewPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.getResume.addListener(_onGetResume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            if (widget.viewModel.getResume.completed) {
              return Text(widget.viewModel.resume!.resumeName);
            }

            return const Text('Carregando...');
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await widget.viewModel.savePdfLocally();
            },
            icon: const Icon(FeatherIcons.refreshCcw),
          ),
          IconButton(
            onPressed: () async {
              await Printing.sharePdf(bytes: widget.viewModel.resumePdf!.readAsBytesSync());
            },
            icon: const Icon(FeatherIcons.share2),
          ),
          // IconButton(
          //   onPressed: () async {
          //     final pdfDoc = await exportDelegate.exportToPdfDocument(pdfId);
          //     final pdf = await pdfDoc.save();
          //     await Printing.layoutPdf(onLayout: (format) => pdf);
          //   },
          //   icon: const Icon(FeatherIcons.share),
          // ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          if (widget.viewModel.getResume.running) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (widget.viewModel.getResume.error) {
            return Center(
              child: Text(
                'Erro ao carregar currículo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          if (widget.viewModel.getResume.completed) {
            // return PdfViewer.openFile(
            //   widget.viewModel.resumePdf!.path,
            //   onError: (error) {
            //     print('DEEEEUUU PAUUUUU');
            //     print(error);
            //   },
            // );
            return SfPdfViewer.file(
              widget.viewModel.resumePdf!,
              pageSpacing: 16,
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Future<void> _onGetResume() async {
    if (widget.viewModel.getResume.error) {}
  }
}
