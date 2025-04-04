import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../shared/extensions/extensions.dart';
import '../../../shared/widgets/cb_text_form_field.dart';

class SectionTitleTextField extends StatefulWidget {
  const SectionTitleTextField({
    super.key,
    required this.text,
    this.padding = 16,
    this.icon = FeatherIcons.fileText,
  });

  final String text;
  final double padding;
  final IconData icon;

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
        child: const CbTextFormField(label: 'Título da Seção'),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding).copyWith(bottom: 16),
      child: Row(
        // spacing: 6,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: context.colors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
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
