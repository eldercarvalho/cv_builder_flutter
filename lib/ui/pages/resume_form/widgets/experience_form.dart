import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/di.dart';
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
  const ExperienceForm({super.key, required this.onSubmit, this.onPrevious, required this.isEditing});

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  final _viewModel = getIt<ResumeFormViewModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const SectionTitleTextField(
          text: 'Experiência Profissional',
          icon: FeatherIcons.briefcase,
        ),
        ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.resume.workExperience.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text('Nenhuma experiência adicionada'),
                ),
              );
            }

            return ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
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
            );
          },
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => _onAddButtonPressed(),
          label: const Text('Adicionar Experiência'),
          icon: const Icon(Icons.add),
        ),
        const Spacer(),
        ListenableBuilder(
          listenable: _viewModel.saveResume,
          builder: (context, _) {
            return FormButtons(
              showIcons: true,
              showSaveButton: widget.isEditing,
              isLoading: _viewModel.saveResume.running,
              previousText: context.l10n.objective,
              onPreviousPressed: widget.onPrevious,
              nextText: context.l10n.education,
              onNextPressed: () {
                widget.onSubmit();
              },
            );
          },
        ),
      ],
    );
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
          _isEditing ? 'Editar Experiência' : 'Adicionar Experiência',
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: FormContainer(
          fields: [
            CbTextFormField(
              controller: _companyController,
              label: 'Empresa',
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextFormField(
              controller: _positionController,
              label: 'Cargo',
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextFormField(
              controller: _websiteController,
              label: 'Site da Empresa',
              suffix: const Icon(FeatherIcons.link),
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
              label: 'Atividades',
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
                Navigator.of(context).pop(WorkExperience(
                  id: _isEditing ? widget.workExperience!.id : const Uuid().v4(),
                  company: _companyController.text,
                  position: _positionController.text,
                  website: _websiteController.text,
                  startDate: format.parse(_startDateController.text),
                  endDate: _endDateController.text.isNotEmpty ? format.parse(_endDateController.text) : null,
                  summary: _summaryController.text,
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
