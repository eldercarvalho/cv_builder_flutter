import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../../domain/models/resume.dart';
import '../../shared/resume_models/simple/simple.dart';
import '../../shared/widgets/widgets.dart';
import 'view_model/resume_form_finished_view_model.dart';

class ResumeFormFinishedPage extends StatefulWidget {
  const ResumeFormFinishedPage({
    super.key,
    required this.resume,
    required this.viewModel,
  });

  static const path = '/resume-form-finished';

  static Future<Object?> push(BuildContext context, Resume resume) async {
    return await context.push(path, extra: resume);
  }

  static Future<void> resplace(BuildContext context, Resume resume) async {
    context.replace(path, extra: resume);
  }

  final Resume resume;
  final ResumeFormFinishedViewModel viewModel;

  @override
  State<ResumeFormFinishedPage> createState() => _ResumeFormFinishedPageState();
}

class _ResumeFormFinishedPageState extends State<ResumeFormFinishedPage> {
  @override
  void initState() {
    widget.viewModel.downloadResume.addListener(_downloadResumeListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/mascot.svg',
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                'Seu novo currículo está TOP!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'Você pode editar as informações na tela de visualização do currículo.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CbButton(
                prefixIcon: FeatherIcons.home,
                onPressed: () => Navigator.of(context).pop(),
                text: 'Ir para tela inicial',
              ),
              const SizedBox(height: 16),
              CbButton(
                prefixIcon: FeatherIcons.file,
                onPressed: () => Navigator.of(context).pop(),
                text: 'Visualizar Currículo',
              ),
              const SizedBox(height: 16),
              CbButton(
                prefixIcon: FeatherIcons.share2,
                onPressed: () => _onShare(),
                text: 'Compartilhar',
                type: CbButtonType.outlined,
              ),
              const SizedBox(height: 16),
              ListenableBuilder(
                listenable: widget.viewModel.downloadResume,
                builder: (context, child) {
                  return CbButton(
                    prefixIcon: FeatherIcons.download,
                    onPressed: () => _onDownload(),
                    text: 'Download',
                    type: CbButtonType.outlined,
                    isLoading: widget.viewModel.downloadResume.running,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onShare() async {
    final resumePdf = await SimpleResumeTemplate.generatePdf(widget.resume);
    await Printing.sharePdf(bytes: resumePdf, filename: '${widget.resume.resumeName}.pdf');
  }

  Future<void> _onDownload() async {
    widget.viewModel.downloadResume.execute(widget.resume);
  }

  void _downloadResumeListener() {
    if (widget.viewModel.downloadResume.completed) {
      context.showSuccessSnackBar('Currículo baixado com sucesso!');
    }
  }
}
