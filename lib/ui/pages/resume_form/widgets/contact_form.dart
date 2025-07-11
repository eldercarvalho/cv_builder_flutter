import 'package:cv_builder/ui/shared/formtatters/mask_fomatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'section_title_text_field.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
  });

  final bool isEditing;
  final Function() onSubmit;
  final Function()? onPrevious;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  late final ResumeFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  @override
  void initState() {
    _viewModel = context.read();
    _phoneController.text = _viewModel.resume.phoneNumber ?? '';
    _phone2Controller.text = _viewModel.resume.phoneNumber2 ?? '';
    _emailController.text = _viewModel.resume.email ?? '';
    _websiteController.text = _viewModel.resume.website ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phone2Controller.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return FormContainer(
            showPreviewButton: !widget.isEditing && !isKeyboardVisible,
            onPreviewButtonPressed: _onPreview,
            title: SectionTitleTextField(
              text: context.l10n.contact,
              padding: 0,
              icon: FeatherIcons.phone,
            ),
            fields: [
              CbTextFormField(
                controller: _phoneController,
                label: context.l10n.phone1,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  MaskFormatter(masks: ['(##) #####-####']),
                ],
              ),
              CbTextFormField(
                controller: _phone2Controller,
                label: context.l10n.phone2,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  MaskFormatter(masks: ['(##) #####-####']),
                ],
              ),
              CbTextFormField(
                controller: _emailController,
                label: context.l10n.email,
                textCapitalization: TextCapitalization.none,
              ),
              CbTextFormField(
                controller: _websiteController,
                label: context.l10n.website,
                textCapitalization: TextCapitalization.none,
                validator: UrlValidator(
                  errorText: context.l10n.invalidUrlError,
                ).call,
              ),
            ],
            bottom: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, child) {
                return FormButtons(
                  step: !isKeyboardVisible ? 4 : null,
                  showIcons: true,
                  showSaveButton: widget.isEditing,
                  isLoading: _viewModel.saveResume.running,
                  previousText: context.l10n.address,
                  onPreviousPressed: widget.onPrevious,
                  nextText: context.l10n.socialNetwork(2),
                  shrink: isKeyboardVisible,
                  onNextPressed: _onNext,
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _onPreview() {
    FocusScope.of(context).unfocus();
    _viewModel.previewResume = _viewModel.resume.copyWith(
      phoneNumber: _phoneController.text.trim(),
      phoneNumber2: _phone2Controller.text.trim(),
      email: _emailController.text.trim(),
      website: _websiteController.text.trim(),
    );
    _viewModel.generatePdf.execute();
  }

  void _onNext() {
    if (_formKey.currentState!.validate()) {
      _viewModel.resume = _viewModel.resume.copyWith(
        phoneNumber: _phoneController.text.trim(),
        phoneNumber2: _phone2Controller.text.trim(),
        email: _emailController.text.trim(),
        website: _websiteController.text.trim(),
      );
      widget.onSubmit();
    }
  }
}
