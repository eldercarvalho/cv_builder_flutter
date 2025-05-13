import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../../domain/models/resume.dart';
import '../../../../domain/models/resume_section.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import 'layout_button.dart';

class SectionSettings extends StatefulWidget {
  const SectionSettings({super.key, required this.section, required this.resume});

  final ResumeSection section;
  final Resume resume;

  @override
  State<SectionSettings> createState() => _SectionSettingsState();
}

class _SectionSettingsState extends State<SectionSettings> {
  final _formKey = GlobalKey<FormState>();
  // final bool _isSubmitted = false;
  final _titleController = TextEditingController();
  bool _hideTitle = false;
  bool _forcePageBreak = false;
  bool _hideDivider = false;
  ResumeSectionLayout? _layout;

  @override
  void initState() {
    _titleController.text = widget.section.title;
    _hideTitle = widget.section.hideTitle;
    _forcePageBreak = widget.section.forcePageBreak;
    _hideDivider = widget.section.hideDivider;
    _layout = widget.section.layout;
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
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _hideDivider,
                      onChanged: (value) => setState(() => _hideDivider = value!),
                      title: Text(context.l10n.previewHideSectionDivider),
                      contentPadding: EdgeInsets.zero,
                      // dense: true,
                    ),
                    if (widget.section.hasLayout && widget.resume.template == ResumeTemplate.basic) ...[
                      const SizedBox(height: 16),
                      Text(context.l10n.previewSectionLayout, style: context.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          LayoutButton(
                            layout: ResumeSectionLayout.list,
                            onPressed: () => setState(() => _layout = ResumeSectionLayout.list),
                            label: context.l10n.previewSectionLayoutList,
                            icon: FeatherIcons.list,
                            isSelected: _layout == ResumeSectionLayout.list,
                          ),
                          const SizedBox(width: 16),
                          LayoutButton(
                            layout: ResumeSectionLayout.grid,
                            onPressed: () => setState(() => _layout = ResumeSectionLayout.grid),
                            label: context.l10n.previewSectionLayoutGrid,
                            icon: FeatherIcons.grid,
                            isSelected: _layout == ResumeSectionLayout.grid,
                          ),
                        ],
                      ),
                    ],
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
                        layout: _layout,
                        hideDivider: _hideDivider,
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
