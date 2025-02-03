import 'package:cv_builder/domain/models/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/cb_text_form_field.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'option_tile.dart';
import 'section_title_text_field.dart';

class LanguagesForm extends StatefulWidget {
  const LanguagesForm({super.key, required this.onSubmit, this.onPrevious, required this.isEditing});

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<LanguagesForm> createState() => _LanguagesFormState();
}

class _LanguagesFormState extends State<LanguagesForm> {
  late final ResumeFormViewModel _viewModel;

  @override
  void initState() {
    _viewModel = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const SectionTitleTextField(text: 'Idiomas', icon: FeatherIcons.flag),
        ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.resume.languages.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text('Nenhum idioma adicionado'),
                ),
              );
            }

            return ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              onReorder: _onReorder,
              itemCount: _viewModel.resume.languages.length,
              itemBuilder: (context, index) {
                final language = _viewModel.resume.languages[index];
                return OptionTile(
                  key: ValueKey(language.id),
                  title: language.name,
                  subtitle: language.fluency,
                  onTap: () => _onAddButtonPressed(itemToEdit: language),
                  onDeleteTap: () => _onRemove(language.id),
                  isLastItem: index == _viewModel.resume.languages.length - 1,
                );
              },
            );
          },
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => _onAddButtonPressed(),
          label: const Text('Adicionar Idioma'),
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
              previousText: context.l10n.skills,
              onPreviousPressed: widget.onPrevious,
              nextText: context.l10n.certifications,
              onNextPressed: () {
                widget.onSubmit();
              },
            );
          },
        ),
      ],
    );
  }

  void _onAddButtonPressed({Language? itemToEdit}) async {
    final Language? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CreateItemModal(language: itemToEdit),
      ),
    );

    if (result != null) {
      if (itemToEdit != null) {
        _viewModel.resume = _viewModel.resume.copyWith(
          languages: _viewModel.resume.languages.map((e) {
            if (e.id == result.id) {
              return result;
            }
            return e;
          }).toList(),
        );
        return;
      }

      _viewModel.resume = _viewModel.resume.copyWith(
        languages: [..._viewModel.resume.languages, result],
      );
    }
  }

  void _onRemove(String id) {
    _viewModel.resume = _viewModel.resume.copyWith(
      languages: _viewModel.resume.languages.where((e) => e.id != id).toList(),
    );
  }

  void _onReorder(oldIndex, index) {
    if (index > oldIndex) {
      index -= 1;
    }
    final languages = _viewModel.resume.languages;
    final language = languages.removeAt(oldIndex);
    languages.insert(index, language);
    _viewModel.resume = _viewModel.resume.copyWith(languages: languages);
  }
}

class _CreateItemModal extends StatefulWidget {
  const _CreateItemModal({this.language});

  final Language? language;

  @override
  State<_CreateItemModal> createState() => _CreateItemModalState();
}

class _CreateItemModalState extends State<_CreateItemModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fluencyController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    if (widget.language != null) {
      _isEditing = true;
      _nameController.text = widget.language!.name;
      _fluencyController.text = widget.language!.fluency ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fluencyController.dispose();
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
              controller: _fluencyController,
              label: 'Fluência',
            )
          ],
          bottom: FormButtons(
            onPreviousPressed: () {
              Navigator.of(context).pop();
            },
            nextText: _isEditing ? 'Salvar' : 'Adicionar',
            onNextPressed: () {
              if (_formKey.currentState!.validate()) {
                final education = Language(
                  id: _isEditing ? widget.language!.id : const Uuid().v4(),
                  name: _nameController.text,
                  fluency: _fluencyController.text,
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
