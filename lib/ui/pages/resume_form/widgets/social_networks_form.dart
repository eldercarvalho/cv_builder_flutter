import 'package:cv_builder/ui/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/models/social_network.dart';
import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'option_tile.dart';
import 'section_title_text_field.dart';

class SocialNetworksForm extends StatefulWidget {
  const SocialNetworksForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
  });

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<SocialNetworksForm> createState() => _SocialNetworksFormState();
}

class _SocialNetworksFormState extends State<SocialNetworksForm> {
  late final ResumeFormViewModel _viewModel;

  @override
  void initState() {
    _viewModel = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      spacing: 0,
      showPreviewButton: !widget.isEditing,
      onPreviewButtonPressed: _onPreview,
      fields: [
        SectionTitleTextField(
          text: context.l10n.socialNetwork(2),
          padding: 0,
          icon: FeatherIcons.share2,
        ),
        ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            if (_viewModel.resume.socialNetworks.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: CbEmptyState(
                  imagePath: 'assets/images/empty.svg',
                  message: context.l10n.noItemAdded('female', context.l10n.socialNetwork(1)),
                  buttonText: context.l10n.addSocialNetwork,
                  onPressed: _onAddButtonPressed,
                ),
              );
            }

            return ReorderableListView.builder(
              // padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              onReorder: _onReorder,
              itemCount: _viewModel.resume.socialNetworks.length,
              itemBuilder: (context, index) {
                final socialNetwork = _viewModel.resume.socialNetworks[index];
                return OptionTile(
                  key: ValueKey(socialNetwork.id),
                  title: socialNetwork.name,
                  subtitle: socialNetwork.username,
                  onTap: () => _onAddButtonPressed(itemToEdit: socialNetwork),
                  onDeleteTap: () => _onRemove(socialNetwork.id),
                  isLastItem: index == _viewModel.resume.socialNetworks.length - 1,
                );
              },
            );
          },
        ),
        Visibility(
          visible: _viewModel.resume.socialNetworks.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: OutlinedButton.icon(
              onPressed: () => _onAddButtonPressed(),
              label: Text(context.l10n.addSocialNetwork),
              icon: const Icon(Icons.add),
            ),
          ),
        ),
      ],
      bottom: ListenableBuilder(
        listenable: _viewModel.saveResume,
        builder: (context, _) {
          return FormButtons(
            isEditing: widget.isEditing,
            step: 5,
            showIcons: true,
            showSaveButton: widget.isEditing,
            isLoading: _viewModel.saveResume.running,
            previousText: context.l10n.contact,
            onPreviousPressed: widget.onPrevious,
            nextText: context.l10n.objective,
            onNextPressed: widget.onSubmit,
          );
        },
      ),
    );
  }

  void _onPreview() {
    _viewModel.previewResume = _viewModel.resume;
    _viewModel.generatePdf.execute();
  }

  void _onAddButtonPressed({SocialNetwork? itemToEdit}) async {
    final SocialNetwork? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CreateItemModal(
          socialNetwork: itemToEdit,
        ),
      ),
    );

    if (result != null) {
      if (itemToEdit != null) {
        _viewModel.resume = _viewModel.resume.copyWith(
          socialNetworks: _viewModel.resume.socialNetworks.map((e) {
            if (e.id == result.id) {
              return result;
            }
            return e;
          }).toList(),
        );
        return;
      }

      _viewModel.resume = _viewModel.resume.copyWith(
        socialNetworks: [..._viewModel.resume.socialNetworks, result],
      );
    }
  }

  void _onRemove(String id) {
    _viewModel.resume = _viewModel.resume.copyWith(
      socialNetworks: _viewModel.resume.socialNetworks.where((e) => e.id != id).toList(),
    );
  }

  void _onReorder(oldIndex, index) {
    if (index > oldIndex) {
      index -= 1;
    }
    final socialNetworks = _viewModel.resume.socialNetworks;
    final socialNetwork = socialNetworks.removeAt(oldIndex);
    socialNetworks.insert(index, socialNetwork);
    _viewModel.resume = _viewModel.resume.copyWith(socialNetworks: socialNetworks);
  }
}

class _CreateItemModal extends StatefulWidget {
  const _CreateItemModal({this.socialNetwork});

  final SocialNetwork? socialNetwork;

  @override
  State<_CreateItemModal> createState() => _CreateItemModalState();
}

class _CreateItemModalState extends State<_CreateItemModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    if (widget.socialNetwork != null) {
      _isEditing = true;
      _nameController.text = widget.socialNetwork!.name;
      _usernameController.text = widget.socialNetwork!.username!;
      _linkController.text = widget.socialNetwork!.url!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addtitle = '${context.l10n.add} ${context.l10n.socialNetwork(1)}';
    final editTitle = '${context.l10n.edit} ${context.l10n.socialNetwork(1)}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? editTitle : addtitle,
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: FormContainer(
          fields: [
            CbTextFormField(
              controller: _nameController,
              label: context.l10n.name,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextFormField(
              controller: _usernameController,
              label: context.l10n.username,
            ),
            CbTextFormField(
              controller: _linkController,
              label: 'Url',
              suffix: const Icon(FeatherIcons.link),
            ),
          ],
          bottom: FormButtons(
            onPreviousPressed: () {
              Navigator.of(context).pop();
            },
            nextText: _isEditing ? context.l10n.save : context.l10n.add,
            onNextPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop(SocialNetwork(
                  id: _isEditing ? widget.socialNetwork!.id : const Uuid().v4(),
                  name: _nameController.text.trim(),
                  username: _usernameController.text.trim(),
                  url: _linkController.text.trim(),
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
