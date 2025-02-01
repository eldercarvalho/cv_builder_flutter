import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../domain/models/resume.dart';
import '../../shared/extensions/extensions.dart';
import 'resume_form_finished_page.dart';
import 'view_model/resume_form_view_model.dart';
import 'widgets/widgets.dart';

enum ResumeFormPageStep {
  resumeInfo,
  personalInfo,
  address,
  contact,
  socialNetworks,
  objective,
  experience,
  education,
  skills,
  languages,
  certifications,
}

class ResumeFormParams {
  final Resume resume;
  final ResumeFormPageStep step;

  ResumeFormParams({required this.resume, required this.step});
}

class ResumeFormPage extends StatefulWidget {
  const ResumeFormPage({
    super.key,
    required this.viewModel,
    this.params,
  });

  final ResumeFormViewModel viewModel;
  final ResumeFormParams? params;

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();

  static const path = '/resume-form';

  static Future<Object?> push(BuildContext context, {ResumeFormParams? params}) async {
    return await context.push(path, extra: params);
  }
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  bool get _isEditing => widget.params != null;

  @override
  void initState() {
    widget.viewModel.saveResume.addListener(_onSaveResumeListener);
    widget.viewModel.generatePdf.addListener(_onGeneratePdfListener);
    super.initState();
    final params = widget.params;
    if (params != null) {
      widget.viewModel.resume = params.resume;
      _pageController = PageController(initialPage: params.step.index);
    } else {
      _pageController = PageController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? 'Editar Currículo' : 'Novo Currículo';

    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopInvokedWithResult,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title, style: context.textTheme.titleLarge),
            actions: [
              if (!_isEditing && _currentPage != 0)
                IconButton(
                  icon: const Icon(FeatherIcons.eye),
                  onPressed: () => widget.viewModel.generatePdf.execute(),
                ),
            ],
          ),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: [
              ResumeInfoForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _pop),
              ProfileForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
              AddressForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
              ContactForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
              SocialNetworksForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
              ObjectiveForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
              ExperienceForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
              EducationForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
              SkillsForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
              LanguagesForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
              CertificationsForm(isEditing: _isEditing, onSubmit: _onSubmit, onPrevious: _onPreviousPage),
            ],
          ),
        ),
      ),
    );
  }

  void _pop() => Navigator.of(context).pop();

  void _onPopInvokedWithResult(bool didPop, Object? result) {
    if (didPop) return;

    if (widget.params != null) {
      Navigator.of(context).pop();
      return;
    }

    if (_pageController.page == 0) {
      Navigator.of(context).pop();
    } else {
      _onPreviousPage();
    }
  }

  void _onNextPage() {
    if (_isEditing) {
      widget.viewModel.saveResume.execute(_isEditing);
      return;
    }

    FocusScope.of(context).unfocus();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();
    widget.viewModel.saveResume.execute(_isEditing);
  }

  void _onSaveResumeListener() {
    if (widget.viewModel.saveResume.completed) {
      if (_isEditing) {
        context.pop();
        return;
      }

      ResumeFormFinishedPage.resplace(context, widget.viewModel.resume);
    }

    if (widget.viewModel.saveResume.error) {
      context.showErrorSnackBar('Ocorreu um erro ao tentar salvar o currículo');
    }
  }

  void _onGeneratePdfListener() {
    if (widget.viewModel.generatePdf.completed) {
      final pdfFile = widget.viewModel.resumePdfFile;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Pré-visualização'),
            ),
            body: SfPdfViewer.file(pdfFile!),
          ),
        ),
      );
    }

    if (widget.viewModel.generatePdf.error) {
      context.showErrorSnackBar('Ocorreu um erro ao tentar gerar a visualização');
    }
  }
}
