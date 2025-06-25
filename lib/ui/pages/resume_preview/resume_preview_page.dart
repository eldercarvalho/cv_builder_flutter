import 'package:cv_builder/ui/shared/extensions/context.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';
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
  final _tooltipKey = GlobalKey<TooltipState>();
  final _tooltipController = SuperTooltipController();
  late ResumeTheme _oldTheme;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _viewModel.resume = widget.params.resume;
    _oldTheme = widget.params.resume.theme;
    _viewModel.getResume.execute(widget.params.resume.id);
    _viewModel.getResume.addListener(_onGetResume);
    _viewModel.deleteResume.addListener(_onDeleteResume);
    _viewModel.updateSections.addListener(_onUpdateSections);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 1), () => _tooltipController.showTooltip());
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          _tooltipController.hideTooltip();
        }
      });
    });
  }

  @override
  void dispose() {
    _viewModel.getResume.removeListener(_onGetResume);
    _viewModel.deleteResume.removeListener(_onDeleteResume);
    _viewModel.updateSections.removeListener(_onUpdateSections);
    _tooltipController.dispose();
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
            if (kDebugMode)
              IconButton(
                onPressed: () => _viewModel.reloadResume.execute(),
                icon: const Icon(FeatherIcons.refreshCw),
              ),
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
            SuperTooltip(
              controller: _tooltipController,
              key: _tooltipKey,
              content: Text(context.l10n.finishedFormShare,
                  style: context.textTheme.labelMedium?.copyWith(color: Colors.white)),
              elevation: 0,
              showBarrier: false,
              arrowLength: 10,
              hasShadow: false,
              borderColor: context.colors.primary,
              backgroundColor: context.colors.primary,
              arrowTipDistance: 16,
              borderRadius: 10,
              bubbleDimensions: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              hideTooltipOnTap: true,
              child: IconButton(
                onPressed: _onShareTap,
                icon: const Icon(FeatherIcons.share2),
              ),
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
                      child: ResizableSplitScreen(
                        isExpanded: _isExpanded,
                        topChild: ListenableBuilder(
                          listenable: _viewModel,
                          builder: (context, child) {
                            return SfPdfViewer.file(
                              _viewModel.resumePdf!,
                              pageSpacing: 16,
                              controller: _pdfViewerController,
                            );
                          },
                        ),
                        bottomChild: CustomBottomSheet(
                          oldTheme: _oldTheme,
                          onCancel: _onCancelColors,
                          onSave: _onSaveColors,
                        ),
                      ),
                    ),
                    PreviewBottomToolbar(
                      isHidden: _isExpanded,
                      onEditTap: () => Scaffold.of(context).openEndDrawer(),
                      onSettingsTap: _onStylesTap,
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

  void _onStylesTap() {
    _oldTheme = _viewModel.resume!.theme;
    setState(() => _isExpanded = !_isExpanded);
  }

  void _onShareTap() {
    _tooltipController.hideTooltip();
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

  void _onCancelColors() {
    if (_viewModel.resume!.theme != _oldTheme) {
      _viewModel.updateTheme(_oldTheme);
    }
    setState(() => _isExpanded = false);
  }

  void _onSaveColors() {
    _viewModel.updateResume.execute();
    setState(() => _isExpanded = false);
  }

  void _onSectionSettings() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SectionsList(resume: _viewModel.resume!),
      ),
    );

    if (result != null) {
      _viewModel.updateSections.execute(result);
    }
  }
}

String disemvowel(String str) {
  return str.replaceAll(RegExp(r'[aeiou]', caseSensitive: false), '');
}
