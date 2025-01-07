import 'package:cv_builder/ui/pages/resume_form/widgets/form_buttons.dart';
import 'package:cv_builder/ui/pages/resume_form/widgets/form_container.dart';
import 'package:cv_builder/ui/shared/extensions/context.dart';
import 'package:flutter/material.dart';

class ResumeInfoForm extends StatefulWidget {
  const ResumeInfoForm({super.key, required this.onNext});

  final Function() onNext;

  @override
  State<ResumeInfoForm> createState() => _ResumeInfoFormState();
}

class _ResumeInfoFormState extends State<ResumeInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      formKey: _formKey,
      fields: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: context.l10n.resumeName,
          ),
        ),
      ],
      bottom: FormButtons(
        onNextPressed: () {
          widget.onNext();
        },
      ),
    );
  }
}
