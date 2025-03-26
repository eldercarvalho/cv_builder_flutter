import 'package:cv_builder/ui/shared/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../config/di.dart';
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
    required this.params,
  });

  final ResumePreviewParams params;

  static const route = '/resume-preview';

  static Future<Object?> push(BuildContext context, {required ResumePreviewParams params}) async {
    return await Navigator.of(context).pushNamed(
      route,
      arguments: params,
    );
  }

  static Future<Object?> pushNamedAndRemoveUntil(
    BuildContext context, {
    required ResumePreviewParams params,
  }) async {
    return await Navigator.of(context).pushNamedAndRemoveUntil(
      route,
      (route) => route.isFirst,
      arguments: params,
    );
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
    _viewModel.updateSections.addListener(_onUpdateSections);
  }

  @override
  void dispose() {
    _viewModel.getResume.removeListener(_onGetResume);
    _viewModel.deleteResume.removeListener(_onDeleteResume);
    _viewModel.updateSections.removeListener(_onUpdateSections);
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
          actions: [
            ListenableBuilder(
              listenable: Listenable.merge([
                _viewModel.updateResume,
                _viewModel.updateSections,
              ]),
              builder: (context, child) {
                if (_viewModel.updateResume.running || _viewModel.updateSections.running) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(context.l10n.saving,
                        style: context.textTheme.labelLarge?.copyWith(color: context.colors.primary)),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            IconButton(
              onPressed: _onShareTap,
              icon: const Icon(FeatherIcons.share2),
            ),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(FeatherIcons.menu),
              );
            }),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: context.colors.outline),
          ),
        ),
        body: ListenableBuilder(
          listenable: Listenable.merge([
            _viewModel.getResume,
            _viewModel.deleteResume,
            _viewModel.reloadResume,
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
                  context.l10n.errorLoadingResume,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            }

            if (_viewModel.getResume.completed) {
              return RepaintBoundary(
                child: Column(
                  children: [
                    Expanded(
                      child: ListenableBuilder(
                        listenable: _viewModel,
                        builder: (context, child) {
                          return SfPdfViewer.file(
                            _viewModel.resumePdf!,
                            pageSpacing: 16,
                            controller: _pdfViewerController,
                          );
                        },
                      ),
                    ),
                    PreviewBottomToolbar(
                      onEditTap: () => Scaffold.of(context).openEndDrawer(),
                      onSettingsTap: _showSettings,
                      onSectionSettings: _onSectionSettings,
                      onShareTap: _onShareTap,
                      onZoomInTap: () => _pdfViewerController.zoomLevel += 0.5,
                      onZoomOutTap: () => _pdfViewerController.zoomLevel -= 0.5,
                      onDeleteTap: _showDeleteDialog,
                    ),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n.errorLoadingResume),
      ));
    }
  }

  Future<void> _onDeleteResume() async {
    if (_viewModel.deleteResume.completed) {
      context.showSuccessSnackBar(context.l10n.previewDeleteSuccess);
      Navigator.of(context).pop(true);
    }

    if (_viewModel.deleteResume.error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n.errorLoadingResume),
      ));
    }
  }

  Future<void> _onUpdateSections() async {
    if (_viewModel.updateSections.error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.l10n.errorLoadingResume),
      ));
    }
  }

  void _onShareTap() {
    Printing.sharePdf(
      bytes: _viewModel.resumePdf!.readAsBytesSync(),
      filename: '${_viewModel.resume!.resumeName}.pdf',
    );
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

  void _showSettings() async {
    final oldTheme = _viewModel.resume!.theme;
    final result = await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      // isScrollControlled: true,
      barrierColor: Colors.transparent,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
      builder: (context) => ChangeNotifierProvider.value(
        value: _viewModel,
        child: CustomBottomSheet(
          oldTheme: oldTheme,
        ),
      ),
    );

    if (result != null && result == true) {
      _viewModel.updateResume.execute();
      return;
    }

    if (oldTheme != _viewModel.resume!.theme) {
      _viewModel.updateTheme(oldTheme);
    }
  }

  void _onSectionSettings() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SectionsList(sections: _viewModel.resume!.sections),
      ),
    );

    if (result != null) {
      _viewModel.updateSections.execute(result);
    }
  }
}
