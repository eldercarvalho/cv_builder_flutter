import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../config/di.dart';
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
    // required this.viewModel,
    this.params,
  });

  // final ResumeFormViewModel viewModel;
  final ResumeFormParams? params;

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();

  static const path = '/resume-form';

  static Future<Object?> push(BuildContext context, {ResumeFormParams? params}) async {
    return await Navigator.of(context).pushNamed(path, arguments: params);
  }
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  final _viewModel = getIt<ResumeFormViewModel>();
  late final PageController _pageController;

  bool get _isEditing => widget.params != null;

  @override
  void initState() {
    _viewModel.saveResume.addListener(_onSaveResumeListener);
    _viewModel.generatePdf.addListener(_onGeneratePdfListener);

    final params = widget.params;
    if (params != null) {
      _viewModel.resume = params.resume;
      _pageController = PageController(initialPage: params.step.index);
    } else {
      _pageController = PageController();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? 'Editar Currículo' : 'Novo Currículo';

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopInvokedWithResult,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title, style: context.textTheme.titleLarge),
            // actions: [
            //   if (!_isEditing && _currentPage != 0)
            //     IconButton(
            //       icon: const Icon(FeatherIcons.eye),
            //       onPressed: () => _viewModel.generatePdf.execute(),
            //     ),
            // ],
          ),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
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
      _viewModel.saveResume.execute(_isEditing);
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
    _viewModel.saveResume.execute(_isEditing);
  }

  void _onSaveResumeListener() {
    if (_viewModel.saveResume.completed) {
      if (_isEditing) {
        context.showSuccessSnackBar('Currículo atualizado!');
        return;
      }

      ResumeFormFinishedPage.resplace(context, _viewModel.resume);
    }

    if (_viewModel.saveResume.error) {
      context.showErrorSnackBar('Ocorreu um erro ao tentar salvar o currículo');
    }
  }

  void _onGeneratePdfListener() {
    if (_viewModel.generatePdf.completed) {
      final pdfFile = _viewModel.resumePdfFile;
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

    if (_viewModel.generatePdf.error) {
      context.showErrorSnackBar('Ocorreu um erro ao tentar gerar a visualização');
    }
  }
}
