import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/models/education.dart';
import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'option_tile.dart';
import 'section_title_text_field.dart';

class EducationForm extends StatefulWidget {
  const EducationForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
  });

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  late final ResumeFormViewModel _viewModel;

  @override
  initState() {
    _viewModel = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      showPreviewButton: !widget.isEditing,
      onPreviewButtonPressed: _onPreview,
      spacing: 0,
      fields: [
        const SectionTitleTextField(
          text: 'Formação',
          icon: Icons.school_outlined,
          padding: 0,
        ),
        ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.resume.education.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text('Nenhuma formação adicionada'),
                ),
              );
            }

            return ReorderableListView.builder(
              // padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              onReorder: _onReorder,
              itemCount: _viewModel.resume.education.length,
              itemBuilder: (context, index) {
                final education = _viewModel.resume.education[index];
                return OptionTile(
                  key: ValueKey(education.id),
                  title: education.fieldOfStudy,
                  subtitle: education.institution,
                  onTap: () => _onAddButtonPressed(itemToEdit: education),
                  onDeleteTap: () => _onRemove(education.id),
                  isLastItem: index == _viewModel.resume.education.length - 1,
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => _onAddButtonPressed(),
          label: const Text('Adicionar Formação'),
          icon: const Icon(Icons.add),
        ),
      ],
      bottom: ListenableBuilder(
        listenable: _viewModel.saveResume,
        builder: (context, _) {
          return FormButtons(
            step: 8,
            showIcons: true,
            showSaveButton: widget.isEditing,
            isLoading: _viewModel.saveResume.running,
            previousText: context.l10n.objective,
            onPreviousPressed: widget.onPrevious,
            nextText: context.l10n.skills,
            onNextPressed: () {
              widget.onSubmit();
            },
          );
        },
      ),
    );
  }

  void _onPreview() {
    _viewModel.previewResume = _viewModel.resume;
    _viewModel.generatePdf.execute();
  }

  void _onAddButtonPressed({Education? itemToEdit}) async {
    final Education? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CreateItemModal(
          education: itemToEdit,
        ),
      ),
    );

    if (result != null) {
      if (itemToEdit != null) {
        _viewModel.resume = _viewModel.resume.copyWith(
          education: _viewModel.resume.education.map((e) {
            if (e.id == result.id) {
              return result;
            }
            return e;
          }).toList(),
        );
        return;
      }

      _viewModel.resume = _viewModel.resume.copyWith(
        education: [..._viewModel.resume.education, result],
      );
    }
  }

  void _onRemove(String id) {
    _viewModel.resume = _viewModel.resume.copyWith(
      education: _viewModel.resume.education.where((e) => e.id != id).toList(),
    );
  }

  void _onReorder(oldIndex, index) {
    if (index > oldIndex) {
      index -= 1;
    }
    final educations = _viewModel.resume.education;
    final experience = educations.removeAt(oldIndex);
    educations.insert(index, experience);
    _viewModel.resume = _viewModel.resume.copyWith(education: educations);
  }
}

class _CreateItemModal extends StatefulWidget {
  const _CreateItemModal({this.education});

  final Education? education;

  @override
  State<_CreateItemModal> createState() => _CreateItemModalState();
}

class _CreateItemModalState extends State<_CreateItemModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _fieldOfStudyController = TextEditingController();
  final TextEditingController _typeOfDegreeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    if (widget.education != null) {
      _isEditing = true;
      _institutionController.text = widget.education!.institution;
      _fieldOfStudyController.text = widget.education!.fieldOfStudy;
      _typeOfDegreeController.text = widget.education!.typeOfDegree ?? '';
      _startDateController.text = DateFormat('dd/MM/yyyy').format(widget.education!.startDate);
      _endDateController.text =
          widget.education!.endDate != null ? DateFormat('dd/MM/yyyy').format(widget.education!.endDate!) : '';
      _summaryController.text = widget.education!.summary ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _fieldOfStudyController.dispose();
    _typeOfDegreeController.dispose();
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
          _isEditing ? 'Editar Formação' : 'Adicionar Formação',
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: FormContainer(
          fields: [
            CbTextFormField(
              controller: _institutionController,
              label: 'Instituição',
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextFormField(
              controller: _fieldOfStudyController,
              label: 'Curso',
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextFormField(
              controller: _typeOfDegreeController,
              label: 'Tipo de Curso',
            ),
            CbDatePicker(
              controller: _startDateController,
              label: 'Data de Início',
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbDatePicker(
              controller: _endDateController,
              label: 'Data de Término',
            ),
            CbTextAreaField(
              controller: _summaryController,
              label: 'Resumo',
              minLines: 6,
            ),
          ],
          bottom: FormButtons(
            onPreviousPressed: () {
              Navigator.of(context).pop();
            },
            nextText: _isEditing ? 'Salvar' : 'Adicionar',
            onNextPressed: () {
              if (_formKey.currentState!.validate()) {
                final format = DateFormat('dd/MM/yyyy');
                final education = Education(
                  id: _isEditing ? widget.education!.id : const Uuid().v4(),
                  institution: _institutionController.text,
                  fieldOfStudy: _fieldOfStudyController.text,
                  typeOfDegree: _typeOfDegreeController.text,
                  startDate: format.parse(_startDateController.text),
                  endDate: _endDateController.text.isNotEmpty ? format.parse(_endDateController.text) : null,
                  summary: _summaryController.text,
                );
                Navigator.of(context).pop(education);
              }
            },
          ),
        ),
      ),
    );
  }
}
