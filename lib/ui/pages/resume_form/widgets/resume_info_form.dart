import 'package:cv_builder/domain/models/resume.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _nameController = TextEditingController();
  String _resumeLanguage = 'pt';
  bool _isSubmitted = false;

  @override
  void initState() {
    _viewModel = context.read();
    _nameController.text = _viewModel.resume.resumeName;
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
    return Form(
      key: _formKey,
      child: FormContainer(
        title: SectionTitleTextField(
          text: context.l10n.resumeInfo,
          icon: FeatherIcons.fileText,
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
              Option(value: 'pt', text: 'Português'),
              Option(value: 'en', text: 'English'),
            ],
            hintText: 'Seleciona o idioma do currículo',
            onChanged: (value) => setState(() => _resumeLanguage = value),
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
              previousText: context.l10n.goBack,
              onPreviousPressed: widget.onPrevious,
              isEditing: widget.isEditing,
              onNextPressed: () {
                _isSubmitted = true;
                if (_formKey.currentState!.validate()) {
                  _viewModel.resume = _viewModel.resume.copyWith(
                    resumeName: _nameController.text.trim(),
                    resumeLanguage: ResumeLanguage.fromString(_resumeLanguage),
                  );
                  widget.onSubmit();
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _setLanguage() {
    final deviceLocale = Localizations.localeOf(context);
    setState(() {
      _resumeLanguage =
          _viewModel.resume.resumeLanguage != null ? _viewModel.resume.resumeLanguage!.name : deviceLocale.languageCode;
    });
  }
}
