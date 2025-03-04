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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: context.colors.surfaceBright,
          borderRadius: BorderRadius.circular(8),
          border: value ? Border.all(color: context.colors.primary, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: IgnorePointer(
                      ignoring: true,
                      child: Checkbox(
                        value: value,
                        onChanged: (value) {},
                        activeColor: context.colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(name, style: context.textTheme.titleMedium),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: TextButton(
                onPressed: onViewPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FeatherIcons.eye, color: context.colors.primary),
                    const SizedBox(width: 8),
                    const Text('Visualizar'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
