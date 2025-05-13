import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/resume_section.dart';

class LayoutButton extends StatelessWidget {
  const LayoutButton({
    super.key,
    required this.layout,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.isSelected,
  });

  final ResumeSectionLayout layout;
  final void Function() onPressed;
  final String label;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        backgroundColor: isSelected ? context.theme.colorScheme.primary : Colors.transparent,
        foregroundColor: isSelected ? context.theme.colorScheme.onPrimary : context.theme.colorScheme.onSurface,
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, color: isSelected ? context.theme.colorScheme.onPrimary : context.theme.colorScheme.onSurface),
          const SizedBox(width: 8),
          Text(label,
              style: context.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? context.theme.colorScheme.onPrimary : context.theme.colorScheme.onSurface)),
        ],
      ),
    );
  }
}
