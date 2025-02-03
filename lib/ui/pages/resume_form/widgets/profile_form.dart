import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/resume.dart';
import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'photo_picker.dart';
import 'section_title_text_field.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
    this.onPreview,
  });

  final bool isEditing;
  final void Function() onSubmit;
  final void Function()? onPrevious;
  final void Function(Resume)? onPreview;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final ResumeFormViewModel _viewModel;
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();

  File? _image;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ResumeFormViewModel>();
    _nameController.text = _viewModel.resume.name;
    _professionController.text = _viewModel.resume.profession ?? '';
    _birthDateController.text = _viewModel.resume.birthDate != null ? _viewModel.resume.birthDate!.toSimpleDate() : '';

    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus) {
        if (_formKey.currentState!.validate()) {}
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _birthDateController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FormContainer(
        fields: [
          SectionTitleTextField(
            text: context.l10n.profile,
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
            focusNode: _nameFocus,
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

  void _onPreview() {
    FocusScope.of(context).unfocus();
    _viewModel.previewResume = _viewModel.resume.copyWith(
      name: _nameController.text,
      profession: _professionController.text,
      birthDate:
          _birthDateController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_birthDateController.text) : null,
      photo: _image?.path,
    );
    _viewModel.generatePdf.execute();
  }
}
