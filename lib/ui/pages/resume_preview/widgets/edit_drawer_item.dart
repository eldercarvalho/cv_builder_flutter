import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

class EditDrawerItem extends StatelessWidget {
  const EditDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colors.primary),
      title: Text(title, style: context.textTheme.labelLarge),
      onTap: onTap,
    );
  }
}
