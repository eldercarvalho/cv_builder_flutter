import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'photo_picker.dart';
import 'section_title_text_field.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
  });

  final bool isEditing;
  final void Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  late final ResumeFormViewModel _viewModel;

  File? _image;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ResumeFormViewModel>();
    _nameController.text = _viewModel.resume.name;
    _professionController.text = _viewModel.resume.profession ?? '';
    _birthDateController.text = _viewModel.resume.birthDate != null ? _viewModel.resume.birthDate!.toSimpleDate() : '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FormContainer(
        fields: [
          SectionTitleTextField(
            text: context.l10n.personalInfo,
            icon: FeatherIcons.user,
            padding: 0,
          ),
          Center(
            child: PhotoPicker(
              initialValue: _viewModel.resume.photo,
              onImagePicked: (image) => setState(() => _image = image),
            ),
          ),
          CbTextFormField(
            controller: _nameController,
            label: context.l10n.name,
            required: true,
            autovalidateMode: _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            validator: MultiValidator([
              RequiredValidator(errorText: context.l10n.requiredField),
              MaxLengthValidator(max: 50, errorText: context.l10n.maxLenghtError(50)),
            ]).call,
          ),
          CbTextFormField(
            controller: _professionController,
            label: context.l10n.profession,
            validator: MultiValidator([
              MaxLengthValidator(max: 50, errorText: context.l10n.maxLenghtError(50)),
            ]).call,
          ),
          CbDatePicker(
            controller: _birthDateController,
            label: context.l10n.birthDate,
          ),
        ],
        bottom: ListenableBuilder(
          listenable: _viewModel.saveResume,
          builder: (context, _) {
            return FormButtons(
              showIcons: true,
              isLoading: _viewModel.saveResume.running,
              showSaveButton: widget.isEditing,
              nextText: context.l10n.address,
              onNextPressed: _onSubmit,
              previousText: context.l10n.resume,
              onPreviousPressed: () => widget.onPrevious?.call(),
            );
          },
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _isSubmitted = true;
      DateFormat format = DateFormat('dd/MM/yyyy');
      _viewModel.resume = _viewModel.resume.copyWith(
        name: _nameController.text,
        profession: _professionController.text,
        birthDate: _birthDateController.text.isNotEmpty ? format.parse(_birthDateController.text) : null,
        photo: _image?.path,
      );
      widget.onSubmit();
    }
  }
}
