import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/resume.dart';
import '../../../../domain/models/template.dart';
import '../../../shared/extensions/context.dart';
import '../view_model/resume_form_view_model.dart';
import 'form_buttons.dart';
import 'section_title_text_field.dart';
import 'template_item.dart';

class TemplateForm extends StatefulWidget {
  const TemplateForm({
    super.key,
    required this.onSubmit,
    this.onPrevious,
    required this.isEditing,
  });

  final bool isEditing;
  final void Function() onSubmit;
  final void Function()? onPrevious;

  @override
  State<TemplateForm> createState() => TemplateFormState();
}

class TemplateFormState extends State<TemplateForm> {
  late final ResumeFormViewModel _viewModel;
  int _templateIndex = 0;
  int _selectedTemplateIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read();
    _templateIndex = _viewModel.resume.template.index;
    _selectedTemplateIndex = _templateIndex;
    _viewModel.addListener(_onResumeListener);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onResumeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final templates = [
      Template(name: context.l10n.basic, imagePath: 'assets/images/basic.jpg'),
      Template(name: context.l10n.modern, imagePath: 'assets/images/modern.jpg'),
    ];

    return Column(
      children: [
        SectionTitleTextField(text: context.l10n.chooseTemplate, icon: FeatherIcons.fileText),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CarouselSlider(
                items: templates
                    .map(
                      (template) => TemplateItem(
                        name: template.name,
                        imagePath: template.imagePath,
                        value: _selectedTemplateIndex == templates.indexOf(template),
                        onChanged: (value) => setState(() => _selectedTemplateIndex = templates.indexOf(template)),
                        onViewPressed: () => _onPreview(template),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  // scrollDirection: Axis.vertical,
                  height: constraints.maxHeight,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,

                  // aspectRatio: 0.8,
                  initialPage: _templateIndex,
                  onPageChanged: (index, reason) => setState(() => _templateIndex = index),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < templates.length; i++)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _templateIndex == i ? context.colors.primary : Colors.grey,
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        ListenableBuilder(
          listenable: _viewModel.saveResume,
          builder: (context, _) {
            return FormButtons(
              showIcons: true,
              isEditing: widget.isEditing,
              showSaveButton: widget.isEditing,
              nextText: context.l10n.resumeAbout,
              previousText: context.l10n.goBack,
              onPreviousPressed: widget.onPrevious,
              onNextPressed: _onSubmit,
              onPassPressed: widget.onPrevious,
              isLoading: _viewModel.saveResume.running,
            );
          },
        ),
      ],
    );
  }

  void _onSubmit() {
    final template = ResumeTemplate.fromIndex(_selectedTemplateIndex);
    final changedTemplate = template.name != _viewModel.resume.template.name;

    _viewModel.resume = _viewModel.resume.copyWith(
      template: template,
      theme: ResumeTheme.getByTemplate(template),
      sections: widget.isEditing
          ? changedTemplate
              ? Resume.orderSectionsByTemplate(
                  template: template,
                  sections: _viewModel.resume.sections,
                )
              : _viewModel.resume.sections
          : Resume.createSectionsByTemplate(template: template),
    );
    widget.onSubmit();
  }

  void _onPreview(Template template) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: 'resume_preview_${template.name}',
                      child: InteractiveViewer(
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: Image.asset(
                          width: double.infinity,
                          template.imagePath,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(FeatherIcons.x, size: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onResumeListener() {
    setState(() {
      _templateIndex = _viewModel.resume.template.index;
    });
  }
}
