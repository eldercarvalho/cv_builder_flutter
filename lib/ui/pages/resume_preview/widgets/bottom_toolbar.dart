import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class PreviewBottomToolbar extends StatelessWidget {
  const PreviewBottomToolbar({
    super.key,
    required this.onEditTap,
    required this.onSettingsTap,
    required this.onSectionSettings,
    required this.onShareTap,
    required this.onZoomInTap,
    required this.onZoomOutTap,
    required this.onDeleteTap,
  });

  final Function() onEditTap;
  final Function() onSettingsTap;
  final Function() onSectionSettings;
  final Function() onShareTap;
  final Function() onZoomInTap;
  final Function() onZoomOutTap;
  final Function() onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Builder(builder: (context) {
              return IconButton(
                onPressed: onEditTap,
                icon: Icon(FeatherIcons.edit, color: context.colors.primary),
              );
            }),
            IconButton(
              onPressed: onSettingsTap,
              icon: Icon(Icons.color_lens_outlined, color: context.colors.primary, size: 28),
            ),
            IconButton(
              onPressed: onSectionSettings,
              icon: Icon(FeatherIcons.list, color: context.colors.primary, size: 28),
            ),
            IconButton(
              onPressed: onShareTap,
              icon: Icon(FeatherIcons.share2, color: context.colors.primary),
            ),
            Container(
              height: 24,
              width: 1,
              color: context.colors.outline,
            ),
            IconButton(
              onPressed: onZoomInTap,
              icon: Icon(FeatherIcons.zoomIn, size: 26, color: context.colors.primary),
            ),
            IconButton(
              onPressed: onZoomOutTap,
              icon: Icon(FeatherIcons.zoomOut, size: 26, color: context.colors.primary),
            ),
            Container(
              height: 24,
              width: 1,
              color: context.colors.outline,
            ),
            IconButton(
              onPressed: onDeleteTap,
              icon: Icon(FeatherIcons.trash2, size: 26, color: context.colors.error),
            ),
          ],
        ),
      ),
    );
  }
}
