import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../../config/di.dart';
import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'section_title_text_field.dart';

class ResumeInfoForm extends StatefulWidget {
  const ResumeInfoForm({super.key, required this.onSubmit, this.onPrevious, required this.isEditing});

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<ResumeInfoForm> createState() => _ResumeInfoFormState();
}

class _ResumeInfoFormState extends State<ResumeInfoForm> {
  final _viewModel = getIt<ResumeFormViewModel>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  bool _isSubmitted = false;

  @override
  void initState() {
    _nameController.text = _viewModel.resume.resumeName;
    super.initState();
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
        fields: [
          const SectionTitleTextField(
            text: 'Sobre o Currículo',
            icon: FeatherIcons.fileText,
            padding: 0,
          ),
          CbTextFormField(
            controller: _nameController,
            autovalidateMode: _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            label: context.l10n.resumeName,
            validator: MultiValidator([
              RequiredValidator(errorText: context.l10n.requiredField),
              MaxLengthValidator(max: 50, errorText: context.l10n.maxLenghtError(50)),
            ]).call,
          ),
        ],
        bottom: ListenableBuilder(
          listenable: _viewModel.saveResume,
          builder: (context, child) {
            return FormButtons(
              showIcons: true,
              showSaveButton: widget.isEditing,
              isLoading: _viewModel.saveResume.running,
              nextText: context.l10n.profile,
              previousText: context.l10n.goBack,
              onPreviousPressed: widget.onPrevious,
              onNextPressed: () {
                if (_formKey.currentState!.validate()) {
                  _isSubmitted = true;
                  _viewModel.resume = _viewModel.resume.copyWith(
                    resumeName: _nameController.text,
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
}
