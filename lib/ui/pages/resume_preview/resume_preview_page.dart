import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../domain/models/resume.dart';
import 'view_model/resume_preview_view_model.dart';
import 'widgets/widgets.dart';

class ResumePreviewParams {
  final Resume resume;

  ResumePreviewParams({required this.resume});
}

class ResumePreviewPage extends StatefulWidget {
  const ResumePreviewPage({
    super.key,
    required this.viewModel,
    required this.params,
  });

  final ResumePreviewViewModel viewModel;
  final ResumePreviewParams params;

  static const route = '/resume-preview';
  static const path = '/resume-preview/:resumeId';

  static Future<void> push(BuildContext context, {required ResumePreviewParams params}) async {
    await context.push('$route/${params.resume.id}', extra: params);
  }

  @override
  State<ResumePreviewPage> createState() => _ResumePreviewPageState();
}

class _ResumePreviewPageState extends State<ResumePreviewPage> {
  ResumePreviewViewModel get _viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel.resume = widget.params.resume;
    _viewModel.getResume.addListener(_onGetResume);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        endDrawer: const EditDrawer(),
        appBar: AppBar(
          title: ListenableBuilder(
            listenable: _viewModel,
            builder: (context, child) {
              return Text(_viewModel.resume?.resumeName ?? "");
            },
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(FeatherIcons.edit),
              );
            }),
          ],
        ),
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            if (_viewModel.getResume.running) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (_viewModel.getResume.error) {
              return Center(
                child: Text(
                  'Erro ao carregar currículo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            }

            if (_viewModel.getResume.completed) {
              return SfPdfViewer.file(
                _viewModel.resumePdf!,
                pageSpacing: 16,
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Future<void> _onGetResume() async {
    if (_viewModel.getResume.error) {}
  }
}
