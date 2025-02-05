import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printing/printing.dart';

import '../../../domain/models/resume.dart';
import '../../shared/resume_models/basic/basic.dart';
import '../../shared/widgets/widgets.dart';
import '../resume_preview/resume_preview_page.dart';

class ResumeFormFinishedPage extends StatefulWidget {
  const ResumeFormFinishedPage({
    super.key,
    required this.resume,
  });

  static const route = '/resume-form-finished';

  static Future<Object?> push(BuildContext context, Resume resume) async {
    return await Navigator.of(context).pushNamed(route, arguments: resume);
  }

  static Future<void> resplace(BuildContext context, Resume resume) async {
    Navigator.of(context).pushReplacementNamed(route, arguments: resume);
  }

  final Resume resume;

  @override
  State<ResumeFormFinishedPage> createState() => _ResumeFormFinishedPageState();
}

class _ResumeFormFinishedPageState extends State<ResumeFormFinishedPage> {
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
                onPressed: () => ResumePreviewPage.replace(context, params: ResumePreviewParams(resume: widget.resume)),
                text: 'Visualizar Currículo',
                type: CbButtonType.outlined,
              ),
              const SizedBox(height: 16),
              CbButton(
                prefixIcon: FeatherIcons.share2,
                onPressed: () => _onShare(),
                text: 'Compartilhar',
                type: CbButtonType.outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onShare() async {
    final resumePdf = await BasicResumeTemplate.generatePdf(widget.resume);
    await Printing.sharePdf(bytes: resumePdf, filename: '${widget.resume.resumeName}.pdf');
  }
}
