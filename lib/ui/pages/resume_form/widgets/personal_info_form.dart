import 'package:cv_builder/ui/shared/extensions/context.dart';
import 'package:flutter/material.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({super.key});

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = '';
    _titleController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.l10n.name,
              ),
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: context.l10n.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
