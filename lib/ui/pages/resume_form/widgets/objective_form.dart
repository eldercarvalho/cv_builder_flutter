import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'section_title_text_field.dart';

class ObjectiveForm extends StatefulWidget {
  const ObjectiveForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
  });

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<ObjectiveForm> createState() => _ObjectiveFormState();
}

class _ObjectiveFormState extends State<ObjectiveForm> {
  late final ResumeFormViewModel _viewModel;
  final TextEditingController _objectiveController = TextEditingController();

  @override
  void initState() {
    _viewModel = context.read();
    _objectiveController.text = _viewModel.resume.objectiveSummary ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _objectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      showPreviewButton: !widget.isEditing,
      onPreviewButtonPressed: _onPreview,
      fields: [
        SectionTitleTextField(
          text: context.l10n.objective,
          padding: 0,
          icon: FeatherIcons.target,
        ),
        CbTextAreaField(
          controller: _objectiveController,
          validator: MultiValidator([
            MaxLengthValidator(max: 500, errorText: context.l10n.maxLenghtError(500)),
          ]).call,
        ),
      ],
      bottom: ListenableBuilder(
        listenable: _viewModel.saveResume,
        builder: (context, _) {
          return FormButtons(
            isEditing: widget.isEditing,
            step: 6,
            showIcons: true,
            showSaveButton: widget.isEditing,
            isLoading: _viewModel.saveResume.running,
            previousText: context.l10n.socialNetwork(2),
            onPreviousPressed: widget.onPrevious,
            nextText: context.l10n.experience(1),
            onNextPressed: () {
              _viewModel.resume = _viewModel.resume.copyWith(
                objectiveSummary: _objectiveController.text.trim(),
              );
              widget.onSubmit();
            },
          );
        },
      ),
    );
  }

  void _onPreview() {
    FocusScope.of(context).unfocus();
    _viewModel.previewResume = _viewModel.resume.copyWith(
      objectiveSummary: _objectiveController.text.trim(),
    );
    _viewModel.generatePdf.execute();
  }
}
