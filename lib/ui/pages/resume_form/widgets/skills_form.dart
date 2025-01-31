import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/models/skill.dart';
import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/cb_text_form_field.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'option_tile.dart';
import 'section_title_text_field.dart';

class SkillsForm extends StatefulWidget {
  const SkillsForm({super.key, required this.onSubmit, this.onPrevious, required this.isEditing});

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<SkillsForm> createState() => _SkillsFormState();
}

class _SkillsFormState extends State<SkillsForm> {
  late final ResumeFormViewModel _viewModel;

  @override
  void initState() {
    _viewModel = context.read<ResumeFormViewModel>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const SectionTitleTextField(
          text: 'Habilidades',
          icon: FeatherIcons.star,
        ),
        ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.resume.skills.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text('Nenhuma habilidade adicionada'),
                ),
              );
            }

            return ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              onReorder: _onReorder,
              itemCount: _viewModel.resume.skills.length,
              itemBuilder: (context, index) {
                final skill = _viewModel.resume.skills[index];
                return OptionTile(
                  key: ValueKey(skill.id),
                  title: skill.name,
                  subtitle: skill.level,
                  onTap: () => _onAddButtonPressed(itemToEdit: skill),
                  onDeleteTap: () => _onRemove(skill.id),
                  isLastItem: index == _viewModel.resume.skills.length - 1,
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => _onAddButtonPressed(),
          label: const Text('Adicionar Habilidade'),
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
              previousText: context.l10n.experience,
              onPreviousPressed: widget.onPrevious,
              nextText: context.l10n.languages,
              onNextPressed: () {
                widget.onSubmit();
              },
            );
          },
        ),
      ],
    );
  }

  void _onAddButtonPressed({Skill? itemToEdit}) async {
    final Skill? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CreateItemModal(skill: itemToEdit),
      ),
    );

    if (result != null) {
      if (itemToEdit != null) {
        _viewModel.resume = _viewModel.resume.copyWith(
          skills: _viewModel.resume.skills.map((e) {
            if (e.id == result.id) {
              return result;
            }
            return e;
          }).toList(),
        );
        return;
      }

      _viewModel.resume = _viewModel.resume.copyWith(
        skills: [..._viewModel.resume.skills, result],
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
  const _CreateItemModal({this.skill});

  final Skill? skill;

  @override
  State<_CreateItemModal> createState() => _CreateItemModalState();
}

class _CreateItemModalState extends State<_CreateItemModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    if (widget.skill != null) {
      _isEditing = true;
      _nameController.text = widget.skill!.name;
      _levelController.text = widget.skill!.level ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar Habilidade' : 'Adicionar Habilidade',
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: FormContainer(
          fields: [
            CbTextFormField(
              controller: _nameController,
              label: 'Nome',
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextFormField(
              controller: _levelController,
              label: 'Nível',
            )
          ],
          bottom: FormButtons(
            onPreviousPressed: () {
              Navigator.of(context).pop();
            },
            nextText: _isEditing ? 'Salvar' : 'Adicionar',
            onNextPressed: () {
              if (_formKey.currentState!.validate()) {
                final education = Skill(
                  id: _isEditing ? widget.skill!.id : const Uuid().v4(),
                  name: _nameController.text,
                  level: _levelController.text,
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
