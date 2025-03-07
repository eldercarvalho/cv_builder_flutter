import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
  late final ResumeFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  final _professionController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();

  File? _image;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read();
    _nameController.text = _viewModel.resume.name;
    _professionController.text = _viewModel.resume.profession ?? '';
    _birthDateController.text = _viewModel.resume.birthDate != null ? _viewModel.resume.birthDate!.toSimpleDate() : '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return FormContainer(
            showPreviewButton: !widget.isEditing,
            onPreviewButtonPressed: _onPreview,
            title: SectionTitleTextField(
              text: context.l10n.profile,
              icon: FeatherIcons.user,
              padding: 0,
            ),
            fields: [
              Center(
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    return PhotoPicker(
                      initialValue: _viewModel.resume.photo,
                      onImagePicked: (image) => setState(() => _image = image),
                      onDelete: () {
                        _viewModel.resume = _viewModel.resume.copyWith(setNullPhoto: true);
                        setState(() => _image = null);
                      },
                    );
                  },
                ),
              ),
              CbTextFormField(
                controller: _nameController,
                label: context.l10n.name,
                required: true,
                autovalidateMode: _isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                validator: MultiValidator([
                  RequiredValidator(errorText: context.l10n.requiredField),
                  MaxLengthValidator(max: 100, errorText: context.l10n.maxLenghtError(100)),
                ]).call,
              ),
              CbTextFormField(
                controller: _professionController,
                label: context.l10n.profession,
                validator: MultiValidator([
                  MaxLengthValidator(max: 100, errorText: context.l10n.maxLenghtError(100)),
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
                  isEditing: widget.isEditing,
                  step: !isKeyboardVisible ? 2 : null,
                  showIcons: true,
                  isLoading: _viewModel.saveResume.running,
                  showSaveButton: widget.isEditing,
                  nextText: context.l10n.address,
                  onNextPressed: _onSubmit,
                  previousText: context.l10n.resume,
                  shrink: isKeyboardVisible,
                  onPreviousPressed: () => widget.onPrevious?.call(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _isSubmitted = true;
      DateFormat format = DateFormat('dd/MM/yyyy');
      _viewModel.resume = _viewModel.resume.copyWith(
        name: _nameController.text.trim(),
        profession: _professionController.text.trim(),
        birthDate: _birthDateController.text.isNotEmpty ? format.parse(_birthDateController.text) : null,
        photo: _image?.path,
      );
      widget.onSubmit();
    }
  }

  void _onPreview() {
    FocusScope.of(context).unfocus();
    _viewModel.previewResume = _viewModel.resume.copyWith(
      name: _nameController.text.trim(),
      profession: _professionController.text.trim(),
      birthDate:
          _birthDateController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_birthDateController.text) : null,
      photo: _image?.path,
    );
    _viewModel.generatePdf.execute();
  }
}
