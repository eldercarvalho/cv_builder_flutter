import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TemplateItem extends StatelessWidget {
  const TemplateItem({
    super.key,
    required this.imagePath,
    required this.name,
    required this.value,
    required this.onChanged,
    required this.onViewPressed,
  });

  final String name;
  final String imagePath;
  final bool value;
  final void Function(bool) onChanged;
  final void Function() onViewPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: value,
                    onChanged: (value) => onChanged(value ?? false),
                    activeColor: context.colors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(name, style: context.textTheme.titleMedium)),
                InkWell(
                  onTap: onViewPressed,
                  child: Icon(FeatherIcons.maximize2, color: context.colors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: context.colors.surfaceBright,
                borderRadius: BorderRadius.circular(8),
                // border: value ? Border.all(color: context.colors.primary, width: 2) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Hero(
                tag: 'resume_preview_$name',
                child: Image.asset(imagePath),
              ),
            ),
            // IconButton(
            //         onPressed: onViewPressed,
            //         icon: Icon(FeatherIcons.maximize2, color: context.colors.primary),
            //       ),
          ],
        ),
      ),
    );
  }
}
