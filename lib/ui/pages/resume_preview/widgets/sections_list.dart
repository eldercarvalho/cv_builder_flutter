import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:cv_builder/ui/shared/widgets/cb_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../../domain/models/resume.dart';
import '../../../../domain/models/resume_section.dart';
import 'section_settings.dart';

class SectionsList extends StatefulWidget {
  const SectionsList({super.key, required this.resume});

  final Resume resume;

  @override
  State<SectionsList> createState() => _SectionsListState();
}

class _SectionsListState extends State<SectionsList> {
  List<ResumeSection> _sections = [];

  @override
  void initState() {
    _sections = List.from(widget.resume.sections);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.previewConfigureSections, style: context.textTheme.titleLarge),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Text(context.l10n.previewConfigurationText, style: context.textTheme.bodyLarge?.copyWith(height: 1.4)),
          ),
          Expanded(
            child: ReorderableListView.builder(
              // padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                final section = _sections[index];
                return Column(
                  key: ValueKey(section.type),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.drag_handle_outlined),
                      title: Text(section.title),
                      trailing: Icon(FeatherIcons.edit, color: context.colors.primary),
                      onTap: () => _onSectionTap(section),
                    ),
                    if (index < _sections.length - 1) const Divider(),
                  ],
                );
              },
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                setState(() {
                  final section = _sections.removeAt(oldIndex);
                  _sections.insert(newIndex, section);
                });
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: CbButton(
                text: context.l10n.save,
                onPressed: () => Navigator.of(context).pop(_sections),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onSectionTap(ResumeSection section) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SectionSettings(section: section, resume: widget.resume),
      ),
    );

    if (result != null) {
      final index = _sections.indexWhere((element) => element.type == result.type);
      if (index != -1) {
        setState(() {
          _sections[index] = result;
        });
      }
    }
  }
}
