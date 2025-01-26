import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/extensions/extensions.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'section_title_text_field.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key, required this.onSubmit, this.onPrevious, required this.isEditing});

  final bool isEditing;
  final Function() onSubmit;
  final Function()? onPrevious;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  late final ResumeFormViewModel _viewModel;

  @override
  void initState() {
    _viewModel = context.read<ResumeFormViewModel>();
    _phoneController.text = _viewModel.resume.phoneNumber ?? '';
    _emailController.text = _viewModel.resume.email ?? '';
    _websiteController.text = _viewModel.resume.website ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FormContainer(
        fields: [
          SectionTitleTextField(
            text: context.l10n.contact,
            padding: 0,
          ),
          CbTextFormField(
            controller: _phoneController,
            label: context.l10n.phone,
          ),
          CbTextFormField(
            controller: _emailController,
            label: context.l10n.email,
          ),
          CbTextFormField(
            controller: _websiteController,
            label: context.l10n.website,
          ),
        ],
        bottom: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return FormButtons(
              showIcons: true,
              showSaveButton: widget.isEditing,
              isLoading: _viewModel.saveResume.running,
              previousText: context.l10n.address,
              onPreviousPressed: widget.onPrevious,
              nextText: context.l10n.socialNetwork(2),
              onNextPressed: () {
                _viewModel.resume = _viewModel.resume.copyWith(
                  phoneNumber: _phoneController.text,
                  email: _emailController.text,
                  website: _websiteController.text,
                );
                widget.onSubmit();
              },
            );
          },
        ),
      ),
    );
  }
}
