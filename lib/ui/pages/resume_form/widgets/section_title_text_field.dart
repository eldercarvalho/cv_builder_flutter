import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/cb_text_form_field.dart';

class SectionTitleTextField extends StatefulWidget {
  const SectionTitleTextField({
    super.key,
    required this.text,
    this.padding = 16,
  });

  final String text;
  final double padding;

  @override
  State<SectionTitleTextField> createState() => _SectionTitleTextFieldState();
}

class _SectionTitleTextFieldState extends State<SectionTitleTextField> {
  final bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.padding),
        child: const CbTextFormField(
          label: 'Título da Seção',
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Row(
        // spacing: 6,
        children: [
          Text(widget.text, style: context.textTheme.titleLarge),
          // InkWell(
          //   onTap: () => setState(() => _isEditing = true),
          //   child: const Icon(FeatherIcons.edit, size: 18),
          // ),
        ],
      ),
    );
  }
}
