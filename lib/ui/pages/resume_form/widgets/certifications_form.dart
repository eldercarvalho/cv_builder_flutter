import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../domain/models/certification.dart';
import '../../../shared/extensions/extensions.dart';
import '../../../shared/validators/validators.dart';
import '../../../shared/widgets/widgets.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'form_container.dart';
import 'option_tile.dart';
import 'section_title_text_field.dart';

class CertificationsForm extends StatefulWidget {
  const CertificationsForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
  });

  final bool isEditing;
  final Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<CertificationsForm> createState() => _CertificationsFormState();
}

class _CertificationsFormState extends State<CertificationsForm> {
  late final ResumeFormViewModel _viewModel;

  @override
  initState() {
    _viewModel = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return FormContainer(
          spacing: 0,
          showPreviewButton: !widget.isEditing,
          showAddButton: _viewModel.resume.certifications.isNotEmpty,
          onPreviewButtonPressed: _onPreview,
          onAddPressed: _onAddButtonPressed,
          title: SectionTitleTextField(
            text: context.l10n.certifications(2),
            icon: FeatherIcons.award,
            padding: 0,
          ),
          fields: [
            Visibility(
              visible: _viewModel.resume.certifications.isNotEmpty,
              replacement: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: CbEmptyState(
                  imagePath: 'assets/images/empty.svg',
                  message: context.l10n.noItemAdded('female', context.l10n.certifications(1)),
                  buttonText: context.l10n.addCertification,
                  onPressed: _onAddButtonPressed,
                ),
              ),
              child: ReorderableListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                onReorder: _onReorder,
                itemCount: _viewModel.resume.certifications.length,
                itemBuilder: (context, index) {
                  final certification = _viewModel.resume.certifications[index];
                  return OptionTile(
                    key: ValueKey(certification.id),
                    title: certification.title,
                    subtitle: certification.issuer,
                    onTap: () => _onAddButtonPressed(itemToEdit: certification),
                    onDeleteTap: () => _onRemove(certification.id),
                    isLastItem: index == _viewModel.resume.certifications.length - 1,
                  );
                },
              ),
            ),
          ],
          bottom: ListenableBuilder(
            listenable: _viewModel.saveResume,
            builder: (context, child) {
              return FormButtons(
                isEditing: widget.isEditing,
                step: 11,
                showIcons: true,
                showSaveButton: widget.isEditing,
                isLoading: _viewModel.saveResume.running,
                onPreviousPressed: widget.onPrevious,
                previousText: context.l10n.skills(2),
                nextText: context.l10n.finish,
                nextIcon: FeatherIcons.checkCircle,
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

  void _onAddButtonPressed({Certification? itemToEdit}) async {
    final Certification? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _CreateItemModal(certification: itemToEdit),
      ),
    );

    if (result != null) {
      if (itemToEdit != null) {
        _viewModel.resume = _viewModel.resume.copyWith(
          certifications: _viewModel.resume.certifications.map((e) {
            if (e.id == result.id) {
              return result;
            }
            return e;
          }).toList(),
        );
        return;
      }

      _viewModel.resume = _viewModel.resume.copyWith(
        certifications: [..._viewModel.resume.certifications, result],
      );
    }
  }

  void _onRemove(String id) {
    _viewModel.resume = _viewModel.resume.copyWith(
      certifications: _viewModel.resume.certifications.where((e) => e.id != id).toList(),
    );
  }

  void _onReorder(oldIndex, index) {
    if (index > oldIndex) {
      index -= 1;
    }
    final certifications = _viewModel.resume.certifications;
    final certification = certifications.removeAt(oldIndex);
    certifications.insert(index, certification);
    _viewModel.resume = _viewModel.resume.copyWith(certifications: certifications);
  }
}

class _CreateItemModal extends StatefulWidget {
  const _CreateItemModal({this.certification});

  final Certification? certification;

  @override
  State<_CreateItemModal> createState() => _CreateItemModalState();
}

class _CreateItemModalState extends State<_CreateItemModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _issuerController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    if (widget.certification != null) {
      _isEditing = true;
      _titleController.text = widget.certification!.title;
      _issuerController.text = widget.certification!.issuer;
      _dateController.text = DateFormat('dd/MM/yyyy').format(widget.certification!.date);
      _summaryController.text = widget.certification!.summary ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _issuerController.dispose();
    _dateController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? context.l10n.editCertification : context.l10n.addCertification,
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Form(
        key: _formKey,
        child: FormContainer(
          fields: [
            CbTextFormField(
              controller: _titleController,
              label: context.l10n.title,
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextFormField(
              controller: _issuerController,
              label: context.l10n.issuer,
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbDatePicker(
              controller: _dateController,
              label: context.l10n.date,
              required: true,
              validator: MultiValidator([
                RequiredValidator(errorText: context.l10n.requiredField),
              ]).call,
            ),
            CbTextAreaField(
              controller: _summaryController,
              label: context.l10n.summary,
              minLines: 6,
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
                final certification = Certification(
                  id: _isEditing ? widget.certification!.id : const Uuid().v4(),
                  title: _titleController.text.trim(),
                  issuer: _issuerController.text.trim(),
                  date: format.parse(_dateController.text),
                  summary: _summaryController.text.trim(),
                );
                Navigator.of(context).pop(certification);
              }
            },
          ),
        ),
      ),
    );
  }
}
