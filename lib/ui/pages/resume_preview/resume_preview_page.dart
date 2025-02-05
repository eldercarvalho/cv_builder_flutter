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

  static Future<void> push(BuildContext context, {required ResumePreviewParams params}) async {
    await Navigator.of(context).pushNamed(route, arguments: params);
  }

  static void replace(BuildContext context, {required ResumePreviewParams params}) {
    Navigator.of(context).pushReplacementNamed(route, arguments: params);
  }

  @override
  State<ResumePreviewPage> createState() => _ResumePreviewPageState();
}

class _ResumePreviewPageState extends State<ResumePreviewPage> {
  final _viewModel = getIt<ResumePreviewViewModel>();

  @override
  void initState() {
    super.initState();
    _viewModel.resume = widget.params.resume;
    _viewModel.getResume.execute(widget.params.resume.id);
    _viewModel.getResume.addListener(_onGetResume);
  }

  @override
  void dispose() {
    _viewModel.getResume.removeListener(_onGetResume);
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
            IconButton(
              onPressed: () => Printing.sharePdf(bytes: _viewModel.resumePdf!.readAsBytesSync()),
              icon: Icon(FeatherIcons.share2, color: context.colors.primary),
            ),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: Icon(FeatherIcons.edit, color: context.colors.primary),
              );
            }),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: context.colors.outline),
          ),
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
    if (_viewModel.getResume.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao carregar currículo'),
        ),
      );
    }
  }
}
