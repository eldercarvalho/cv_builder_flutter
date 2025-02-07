import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: context.theme.dividerColor,
          ),
        ),
      ],
    );
  }
}
