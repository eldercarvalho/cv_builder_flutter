import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ToolbarButton extends StatelessWidget {
  const ToolbarButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, color: context.colors.primary, size: 26),
          const SizedBox(height: 4),
          Text(
            text,
            style: context.textTheme.bodySmall!.copyWith(color: context.colors.primary),
          ),
        ],
      ),
    );
  }
}
