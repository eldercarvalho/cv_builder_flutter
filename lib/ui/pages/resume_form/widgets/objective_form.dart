import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'section_title_text_field.dart';

class ObjectiveForm extends StatefulWidget {
  const ObjectiveForm({super.key, required this.onSubmit, this.onPrevious, required this.isEditing});

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<ObjectiveForm> createState() => _ObjectiveFormState();
}

class _ObjectiveFormState extends State<ObjectiveForm> {
  final TextEditingController _objectiveController = TextEditingController();

  late final ResumeFormViewModel _viewModel;

  @override
  void initState() {
    _viewModel = context.read<ResumeFormViewModel>();
    _objectiveController.text = _viewModel.resume.objectiveSummary ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      fields: [
        const SectionTitleTextField(text: 'Objetivo', padding: 0),
        CbTextAreaField(
          controller: _objectiveController,
        ),
      ],
      bottom: ListenableBuilder(
        listenable: _viewModel.saveResume,
        builder: (context, _) {
          return FormButtons(
            showIcons: true,
            showSaveButton: widget.isEditing,
            isLoading: _viewModel.saveResume.running,
            previousText: context.l10n.socialNetwork(2),
            onPreviousPressed: widget.onPrevious,
            nextText: context.l10n.experience,
            onNextPressed: () {
              _viewModel.resume = _viewModel.resume.copyWith(
                objectiveSummary: _objectiveController.text,
              );
              widget.onSubmit();
            },
          );
        },
      ),
    );
  }
}
