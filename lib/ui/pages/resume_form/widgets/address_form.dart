import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:cv_builder/ui/shared/formtatters/mask_fomatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'section_title_text_field.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({super.key, required this.onSubmit, this.onPrevious, required this.isEditing});

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  late final ResumeFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  @override
  void initState() {
    _viewModel = context.read();
    _addressController.text = _viewModel.resume.address ?? '';
    _cityController.text = _viewModel.resume.city ?? '';
    _zipCodeController.text = _viewModel.resume.zipCode ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return FormContainer(
          showPreviewButton: !widget.isEditing,
          onPreviewButtonPressed: _onPreview,
          title: SectionTitleTextField(
            text: context.l10n.address,
            padding: 0,
            icon: FeatherIcons.mapPin,
          ),
          fields: [
            CbTextFormField(
              controller: _addressController,
              label: context.l10n.address,
            ),
            CbTextFormField(
              controller: _cityController,
              label: context.l10n.city,
            ),
            CbTextFormField(
              controller: _zipCodeController,
              label: context.l10n.zipCode,
              inputFormatters: [
                MaskFormatter(masks: ['#####-###']),
              ],
            ),
          ],
          bottom: ListenableBuilder(
            listenable: _viewModel.saveResume,
            builder: (context, _) {
              return FormButtons(
                isEditing: widget.isEditing,
                step: !isKeyboardVisible ? 3 : null,
                showIcons: true,
                showSaveButton: widget.isEditing,
                isLoading: _viewModel.saveResume.running,
                previousText: context.l10n.profile,
                onPreviousPressed: widget.onPrevious,
                nextText: context.l10n.contact,
                shrink: isKeyboardVisible,
                onNextPressed: _onSubmit,
              );
            },
          ),
        );
      }),
    );
  }

  void _onPreview() {
    FocusScope.of(context).unfocus();
    _viewModel.previewResume = _viewModel.resume.copyWith(
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      zipCode: _zipCodeController.text.trim(),
    );
    _viewModel.generatePdf.execute();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      _viewModel.resume = _viewModel.resume.copyWith(
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
      );
      widget.onSubmit();
    }
  }
}
