import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../config/di.dart';
import '../../../domain/models/resume.dart';
import '../../../domain/utils/get_fake_resume.dart';
import '../../shared/extensions/extensions.dart';
import 'resume_form_finished_page.dart';
import 'view_model/resume_form_view_model.dart';
import 'widgets/template_form.dart';
import 'widgets/widgets.dart';

enum ResumeFormPageStep {
  template,
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
    this.params,
  });

  final ResumeFormParams? params;

  @override
  State<ResumeFormPage> createState() => _ResumeFormPageState();

  static const route = '/resume-form';

  static Future<Object?> push(BuildContext context, {ResumeFormParams? params}) async {
    return await Navigator.of(context).pushNamed(route, arguments: params);
  }
}

class _ResumeFormPageState extends State<ResumeFormPage> {
  final _viewModel = getIt<ResumeFormViewModel>();
  late final PageController _pageController;
  int _currentPage = 0;

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
  void dispose() {
    _viewModel.saveResume.removeListener(_onSaveResumeListener);
    _viewModel.generatePdf.removeListener(_onGeneratePdfListener);
    _pageController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? context.l10n.resumeFormEditTitle : context.l10n.resumeFormNewTitle;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopInvokedWithResult,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              if (!_isEditing && _currentPage == 0)
                IconButton(
                  onPressed: () => _showImportJsonDialog(),
                  icon: const Icon(FeatherIcons.download),
                ),
              if (kDebugMode)
                IconButton(
                  icon: const Icon(FeatherIcons.plus),
                  onPressed: () => _viewModel.resume = createFakeResume(),
                ),
            ],
          ),
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            children: [
              TemplateForm(onSubmit: _onNextPage, isEditing: _isEditing, onPrevious: _pop),
              ResumeInfoForm(isEditing: _isEditing, onSubmit: _onNextPage, onPrevious: _onPreviousPage),
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
      FocusScope.of(context).unfocus();
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
    FocusScope.of(context).unfocus();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onSubmit() async {
    FocusScope.of(context).unfocus();

    if (_isEditing) {
      FocusScope.of(context).unfocus();
      _viewModel.saveResume.execute(_isEditing);
      return;
    }

    await ResumeFormFinishedPage.push(context, _viewModel.resume);
    if (mounted) Navigator.of(context).pop(true);
  }

  void _onSaveResumeListener() {
    if (_viewModel.saveResume.completed) {
      if (_isEditing) {
        context.showSuccessSnackBar(context.l10n.resumeFormEditSuccess);
        Navigator.of(context).pop(true);
        return;
      }

      ResumeFormFinishedPage.resplace(context, _viewModel.resume);
    }

    if (_viewModel.saveResume.error) {
      context.showErrorSnackBar(context.l10n.resumeFormEditError);
    }
  }

  void _onGeneratePdfListener() {
    if (_viewModel.generatePdf.completed) {
      final pdfFile = _viewModel.resumePdfFile;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResumePreview(pdfFile: pdfFile!),
        ),
      );
    }

    if (_viewModel.generatePdf.error) {
      context.showErrorSnackBar('Ocorreu um erro ao tentar gerar a visualização');
    }
  }

  void _showImportJsonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.importJsonTitle, style: context.textTheme.titleMedium),
        content: Text(context.l10n.importJsonContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => _importJson(),
            child: Text(context.l10n.select),
          ),
        ],
      ),
    );
  }

  void _importJson() async {
    Navigator.of(context).pop();
    final resultFile = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (resultFile != null) {
      final file = File(resultFile.files.first.path!);
      final json = jsonDecode(await file.readAsString());
      _viewModel.importJson(json);
      if (mounted) {
        context.showSuccessSnackBar(context.l10n.importSuccess);
      }
    }
  }
}
