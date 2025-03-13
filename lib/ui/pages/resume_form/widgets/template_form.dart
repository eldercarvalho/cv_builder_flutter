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

  @override
  void initState() {
    super.initState();
    _viewModel = context.read();
    _templateIndex = _viewModel.resume.template.index;
  }

  @override
  void dispose() {
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
          // child: CarouselSlider(
          //   items: templates
          //       .map(
          //         (template) => TemplateItem(
          //           name: template.name,
          //           imagePath: template.imagePath,
          //           value: _templateIndex == templates.indexOf(template),
          //           onChanged: (value) => setState(() => _templateIndex = templates.indexOf(template)),
          //           onViewPressed: () => _onPreview(template),
          //         ),
          //       )
          //       .toList(),
          //   options: CarouselOptions(
          //     scrollDirection: Axis.vertical,
          //     // height: 400,
          //     enableInfiniteScroll: false,
          //     enlargeCenterPage: true,
          //     viewportFraction: 0.8,
          //     initialPage: _templateIndex,
          //     onPageChanged: (index, reason) => setState(() => _templateIndex = index),
          //   ),
          // ),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 12, bottom: 24),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return TemplateItem(
                name: template.name,
                imagePath: template.imagePath,
                value: index == _templateIndex,
                onChanged: (value) => setState(() => _templateIndex = index),
                onViewPressed: () => _onPreview(template),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ),
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
    final template = ResumeTemplate.fromIndex(_templateIndex);
    _viewModel.resume = _viewModel.resume.copyWith(
      template: template,
      theme: ResumeTheme.getByTemplate(template),
    );
    widget.onSubmit();
  }

  void _onPreview(Template template) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    width: double.infinity,
                    template.imagePath,
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
}
