import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/resume.dart';
import '../../../../domain/templates/texts.dart';
import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'section_title_text_field.dart';

class ResumeInfoForm extends StatefulWidget {
  const ResumeInfoForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
  });

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<ResumeInfoForm> createState() => _ResumeInfoFormState();
}

class _ResumeInfoFormState extends State<ResumeInfoForm> {
  late final ResumeFormViewModel _viewModel; // = getIt<ResumeFormViewModel>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _resumeLanguage = 'pt';
  String? _resumeToCopy;
  bool _isSubmitted = false;
  bool _isNameFieldFilled = false;

  @override
  void initState() {
    _viewModel = context.read();
    _nameController.text = _viewModel.resume.resumeName;
    _isNameFieldFilled = _viewModel.resume.resumeName.isNotEmpty;
    // _resumeToCopy =
    _nameController.addListener(() {
      setState(() {
        _isNameFieldFilled = _nameController.text.isNotEmpty;
      });
    });
    super.initState();
    Future.microtask(() {
      _setLanguage();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Form(
          key: _formKey,
          child: FormContainer(
            title: SectionTitleTextField(
              text: context.l10n.resumeAbout,
              icon: FeatherIcons.info,
              padding: 0,
            ),
            fields: [
              CbTextFormField(
                controller: _nameController,
                autovalidateMode: _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                label: context.l10n.resumeName,
                validator: MultiValidator([
                  RequiredValidator(errorText: context.l10n.requiredField),
                  MaxLengthValidator(max: 50, errorText: context.l10n.maxLenghtError(50)),
                ]).call,
              ),
              CbDropdown(
                initialValue: _resumeLanguage,
                labelText: context.l10n.languages(1),
                options: [
                  Option(value: 'pt', text: context.l10n.portuguese),
                  Option(value: 'en', text: context.l10n.english),
                  Option(value: 'es', text: context.l10n.spanish),
                ],
                onChanged: (value) => setState(() => _resumeLanguage = value),
              ),
              Visibility(
                visible: _viewModel.resumes.isNotEmpty && !widget.isEditing,
                child: CbDropdown(
                  initialValue: _resumeToCopy,
                  labelText: context.l10n.copyResume,
                  disabled: !_isNameFieldFilled,
                  options: List.generate(_viewModel.resumes.length, (index) {
                    final resume = _viewModel.resumes[index];
                    return Option(value: resume.id, text: resume.resumeName);
                  }),
                  onChanged: (value) {
                    _viewModel.copyDataFromResume(value);
                    setState(() => _resumeToCopy = value);
                  },
                ),
              ),
            ],
            bottom: ListenableBuilder(
              listenable: _viewModel.saveResume,
              builder: (context, child) {
                return FormButtons(
                  step: 1,
                  showIcons: true,
                  showSaveButton: widget.isEditing,
                  isLoading: _viewModel.saveResume.running,
                  nextText: context.l10n.profile,
                  previousText: context.l10n.template,
                  onPreviousPressed: widget.onPrevious,
                  isEditing: widget.isEditing,
                  onNextPressed: _onSubmit,
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _onSubmit() {
    _isSubmitted = true;
    if (_formKey.currentState!.validate()) {
      final texts = getTexts(ResumeLanguage.fromString(_resumeLanguage));
      _viewModel.resume = _viewModel.resume.copyWith(
        resumeName: _nameController.text.trim(),
        resumeLanguage: ResumeLanguage.fromString(_resumeLanguage),
        sections: Resume.getSectionsByTemplate(
          template: _viewModel.resume.template,
          objectiveTitle: texts.objective,
          experienceTitle: texts.experience,
          educationTitle: texts.education,
          skillsTitle: texts.skills,
          languagesTitle: texts.languages,
          certificationsTitle: texts.certifications,
          projectsTitle: texts.projects,
          contactTitle: texts.contact,
          referencesTitle: '',
          hobbiesTitle: '',
        ),
      );
      widget.onSubmit();
    }
  }

  void _setLanguage() {
    final deviceLocale = Localizations.localeOf(context);
    setState(() {
      _resumeLanguage =
          _viewModel.resume.resumeLanguage != null ? _viewModel.resume.resumeLanguage!.name : deviceLocale.languageCode;
    });
  }
}
