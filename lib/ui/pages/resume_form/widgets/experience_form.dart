import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/models/work_experience.dart';
import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'option_tile.dart';
import 'section_title_text_field.dart';

class ExperienceForm extends StatefulWidget {
  const ExperienceForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
  });

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  late final ResumeFormViewModel _viewModel;

  @override
  void initState() {
    _viewModel = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return FormContainer(
          showPreviewButton: !widget.isEditing,
          onPreviewButtonPressed: _onPreview,
          showAddButton: _viewModel.resume.workExperience.isNotEmpty,
          onAddPressed: _onAddButtonPressed,
          spacing: 0,
          title: SectionTitleTextField(
            text: context.l10n.professionalExperience,
            icon: FeatherIcons.briefcase,
            padding: 0,
          ),
          fields: [
            Visibility(
              visible: _viewModel.resume.workExperience.isNotEmpty,
              replacement: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: CbEmptyState(
                  imagePath: 'assets/images/empty.svg',
                  message: context.l10n.noItemAdded('female', context.l10n.experience(1)),
                  buttonText: context.l10n.addExperience,
                  onPressed: _onAddButtonPressed,
                ),
              ),
              child: ReorderableListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                onReorder: _onReorder,
                itemCount: _viewModel.resume.workExperience.length,
                itemBuilder: (context, index) {
                  final experience = _viewModel.resume.workExperience[index];
                  return OptionTile(
                    key: ValueKey(experience.id),
                    title: experience.company,
                    subtitle: experience.position,
                    onTap: () => _onAddButtonPressed(itemToEdit: experience),
                    onDeleteTap: () => _onRemove(experience.id),
                    isLastItem: index == _viewModel.resume.workExperience.length - 1,
                  );
                },
              ),
            ),
          ],
          bottom: ListenableBuilder(
            listenable: _viewModel.saveResume,
            builder: (context, _) {
              return FormButtons(
                isEditing: widget.isEditing,
                step: 7,
                showIcons: true,
                showSaveButton: widget.isEditing,
                isLoading: _viewModel.saveResume.running,
                previousText: context.l10n.objective,
                onPreviousPressed: widget.onPrevious,
                nextText: context.l10n.education(1),
                onNextPressed: () {
                  widget.onSubmit();
                },
              );
            },
          ),
        );
      },
    );
  }

  void _onPreview() {
    _viewModel.previewResume = _viewModel.resume;
    _viewModel.generatePdf.execute();
  }

  void _onAddButtonPressed({WorkExperience? itemToEdit}) async {
    final WorkExperience? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CreateItemModal(
          workExperience: itemToEdit,
        ),
      ),
    );

    if (result != null) {
      if (itemToEdit != null) {
        _viewModel.resume = _viewModel.resume.copyWith(
          workExperience: _viewModel.resume.workExperience.map((e) {
            if (e.id == result.id) {
              return result;
            }
            return e;
          }).toList(),
        );
        return;
      }

      _viewModel.resume = _viewModel.resume.copyWith(
        workExperience: [..._viewModel.resume.workExperience, result],
      );
    }
  }

  void _onRemove(String id) {
    _viewModel.resume = _viewModel.resume.copyWith(
      workExperience: _viewModel.resume.workExperience.where((e) => e.id != id).toList(),
    );
  }

  void _onReorder(oldIndex, index) {
    if (index > oldIndex) {
      index -= 1;
    }
    final experiences = _viewModel.resume.workExperience;
    final experience = experiences.removeAt(oldIndex);
    experiences.insert(index, experience);
    _viewModel.resume = _viewModel.resume.copyWith(workExperience: experiences);
  }
}

class _CreateItemModal extends StatefulWidget {
  const _CreateItemModal({this.workExperience});

  final WorkExperience? workExperience;

  @override
  State<_CreateItemModal> createState() => _CreateItemModalState();
}

class _CreateItemModalState extends State<_CreateItemModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    if (widget.workExperience != null) {
      _isEditing = true;
      _companyController.text = widget.workExperience!.company;
      _positionController.text = widget.workExperience!.position;
      _websiteController.text = widget.workExperience!.website;
      _startDateController.text = DateFormat('dd/MM/yyyy').format(widget.workExperience!.startDate);
      _endDateController.text = widget.workExperience!.endDate != null
          ? DateFormat('dd/MM/yyyy').format(widget.workExperience!.endDate!)
          : '';
      _summaryController.text = widget.workExperience!.summary ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _websiteController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? context.l10n.editExperience : context.l10n.addExperience,
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: FormContainer(
          fields: [
            CbTextFormField(
              controller: _companyController,
              label: context.l10n.company,
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextFormField(
              controller: _positionController,
              label: context.l10n.position,
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextFormField(
              controller: _websiteController,
              label: context.l10n.website,
              textCapitalization: TextCapitalization.none,
              // suffix: const Icon(FeatherIcons.link),
              validator: UrlValidator(
                errorText: context.l10n.invalidUrlError,
              ).call,
            ),
            CbDatePicker(
              controller: _startDateController,
              label: context.l10n.startDate,
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbDatePicker(
              controller: _endDateController,
              label: context.l10n.endDate,
            ),
            CbTextAreaField(
              controller: _summaryController,
              label: context.l10n.summary,
            ),
          ],
          bottom: FormButtons(
            onPreviousPressed: () {
              Navigator.of(context).pop();
            },
            nextText: _isEditing ? context.l10n.edit : context.l10n.add,
            onNextPressed: () {
              if (_formKey.currentState!.validate()) {
                final format = DateFormat('dd/MM/yyyy');
                Navigator.of(context).pop(WorkExperience(
                  id: _isEditing ? widget.workExperience!.id : const Uuid().v4(),
                  company: _companyController.text.trim(),
                  position: _positionController.text.trim(),
                  website: _websiteController.text.trim(),
                  startDate: format.parse(_startDateController.text),
                  endDate: _endDateController.text.isNotEmpty ? format.parse(_endDateController.text) : null,
                  summary: _summaryController.text.trim(),
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
