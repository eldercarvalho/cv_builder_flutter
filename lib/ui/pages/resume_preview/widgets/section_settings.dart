import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/resume_section.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';

class SectionSettings extends StatefulWidget {
  const SectionSettings({super.key, required this.section});

  final ResumeSection section;

  @override
  State<SectionSettings> createState() => _SectionSettingsState();
}

class _SectionSettingsState extends State<SectionSettings> {
  final _formKey = GlobalKey<FormState>();
  // final bool _isSubmitted = false;
  final _titleController = TextEditingController();
  bool _hideTitle = false;
  bool _forcePageBreak = false;

  @override
  void initState() {
    _titleController.text = widget.section.title;
    _hideTitle = widget.section.hideTitle;
    _forcePageBreak = widget.section.forcePageBreak;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.section.title, style: context.textTheme.titleLarge),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CbTextFormField(
                      controller: _titleController,
                      label: context.l10n.title,
                      validator: MultiValidator([
                        RequiredValidator(errorText: context.l10n.requiredField),
                        MaxLengthValidator(max: 50, errorText: context.l10n.maxLenghtError(50)),
                      ]).call,
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _hideTitle,
                      onChanged: (value) => setState(() => _hideTitle = value!),
                      title: Text(context.l10n.previewHideSectionTitle),
                      contentPadding: EdgeInsets.zero,
                      // dense: true,
                    ),
                    // CheckboxListTile(
                    //   controlAffinity: ListTileControlAffinity.leading,
                    //   value: _forcePageBreak,
                    //   onChanged: (value) => setState(() => _forcePageBreak = value!),
                    //   title: const Text('Forçar quebra de página'),
                    //   contentPadding: EdgeInsets.zero,
                    //   // dense: true,
                    // ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CbButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedSection = widget.section.copyWith(
                        title: _titleController.text,
                        hideTitle: _hideTitle,
                        forcePageBreak: _forcePageBreak,
                      );
                      Navigator.pop(context, updatedSection);
                    }
                  },
                  text: context.l10n.save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
