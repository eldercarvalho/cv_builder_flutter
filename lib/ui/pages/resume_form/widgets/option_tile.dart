import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.onDeleteTap,
    required this.isLastItem,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final Function() onTap;
  final Function() onDeleteTap;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: !isLastItem
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            if (icon != null) Padding(padding: const EdgeInsets.only(right: 10), child: icon),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  if (subtitle != null && subtitle!.isNotEmpty) Text(subtitle!, style: context.textTheme.bodyMedium),
                ],
              ),
            ),
            IconButton(
              onPressed: onDeleteTap,
              icon: Icon(FeatherIcons.trash2, color: context.colors.error),
            ),
          ],
        ),
      ),
    );
  }
}
