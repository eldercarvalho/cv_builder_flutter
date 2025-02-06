import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../config/di.dart';
import '../../../domain/models/resume.dart';
import '../../shared/extensions/extensions.dart';
import 'view_model/resume_preview_view_model.dart';
import 'widgets/widgets.dart';

class ResumePreviewParams {
  final Resume resume;

  ResumePreviewParams({required this.resume});
}

class ResumePreviewPage extends StatefulWidget {
  const ResumePreviewPage({
    super.key,
    required this.params,
  });

  final ResumePreviewParams params;

  static const route = '/resume-preview';

  static Future<Object?> push(BuildContext context, {required ResumePreviewParams params}) async {
    return await Navigator.of(context).pushNamed(route, arguments: params);
  }

  static void replace(BuildContext context, {required ResumePreviewParams params}) {
    Navigator.of(context).pushReplacementNamed(route, arguments: params);
  }

  @override
  State<ResumePreviewPage> createState() => _ResumePreviewPageState();
}

class _ResumePreviewPageState extends State<ResumePreviewPage> {
  final _viewModel = getIt<ResumePreviewViewModel>();
  final _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    _viewModel.resume = widget.params.resume;
    _viewModel.getResume.execute(widget.params.resume.id);
    _viewModel.getResume.addListener(_onGetResume);
    _viewModel.deleteResume.addListener(_onDeleteResume);
  }

  @override
  void dispose() {
    _viewModel.getResume.removeListener(_onGetResume);
    _viewModel.deleteResume.removeListener(_onDeleteResume);
    super.dispose();
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
          actions: const [],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: context.colors.outline),
          ),
        ),
        body: ListenableBuilder(
          listenable: Listenable.merge([
            _viewModel.getResume,
            _viewModel.deleteResume,
          ]),
          builder: (context, child) {
            if (_viewModel.getResume.running || _viewModel.deleteResume.running) {
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
              return RepaintBoundary(
                child: Column(
                  children: [
                    Expanded(
                      child: SfPdfViewer.file(
                        _viewModel.resumePdf!,
                        pageSpacing: 16,
                        controller: _pdfViewerController,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.shadow.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Builder(builder: (context) {
                            return IconButton(
                              onPressed: () => Scaffold.of(context).openEndDrawer(),
                              icon: Icon(FeatherIcons.edit, color: context.colors.primary),
                            );
                          }),
                          IconButton(
                            onPressed: () => Printing.sharePdf(
                                bytes: _viewModel.resumePdf!.readAsBytesSync(),
                                filename: '${_viewModel.resume!.resumeName}.pdf'),
                            icon: Icon(FeatherIcons.share2, color: context.colors.primary),
                          ),
                          Container(
                            height: 24,
                            width: 1,
                            color: context.colors.outline,
                          ),
                          IconButton(
                            onPressed: () => _pdfViewerController.zoomLevel += 0.5,
                            icon: Icon(FeatherIcons.zoomIn, size: 26, color: context.colors.primary),
                          ),
                          IconButton(
                            onPressed: () => _pdfViewerController.zoomLevel -= 0.5,
                            icon: Icon(FeatherIcons.zoomOut, size: 26, color: context.colors.primary),
                          ),
                          Container(
                            height: 24,
                            width: 1,
                            color: context.colors.outline,
                          ),
                          IconButton(
                            onPressed: _showDeleteDialog,
                            icon: Icon(FeatherIcons.trash2, size: 26, color: context.colors.error),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Future<void> _onGetResume() async {
    if (_viewModel.getResume.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar currículo'),
        ),
      );
    }
  }

  Future<void> _onDeleteResume() async {
    if (_viewModel.deleteResume.completed) {
      context.showSuccessSnackBar('Currículo excluído com sucesso');
      Navigator.of(context).pop(true);
    }

    if (_viewModel.deleteResume.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao deletar o currículo'),
        ),
      );
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.previewDeleteAlertTitle, style: context.textTheme.titleLarge),
        content: Text(context.l10n.previewDeleteAlertMessage, style: context.textTheme.bodyLarge),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.previewDeleteAlertCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _viewModel.deleteResume.execute();
            },
            child: Text(context.l10n.previewDeleteAlertConfirm,
                style: context.textTheme.labelLarge?.copyWith(color: context.colors.error)),
          ),
        ],
      ),
    );
  }
}
