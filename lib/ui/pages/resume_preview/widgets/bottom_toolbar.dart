import 'package:cv_builder/ui/pages/resume_preview/widgets/toolbar_button.dart';
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
    required this.isHidden,
  });

  final Function() onEditTap;
  final Function() onSettingsTap;
  final Function() onSectionSettings;
  final Function() onShareTap;
  final Function() onZoomInTap;
  final Function() onZoomOutTap;
  final Function() onDeleteTap;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: isHidden ? 0 : 64.0,
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
            spacing: 4,
            children: [
              Builder(builder: (context) {
                return ToolbarButton(
                  onPressed: onEditTap,
                  icon: FeatherIcons.edit,
                  text: context.l10n.edit,
                );
              }),
              ToolbarButton(
                text: context.l10n.colors,
                onPressed: onSettingsTap,
                icon: Icons.color_lens_outlined,
              ),
              ToolbarButton(
                text: context.l10n.sections,
                onPressed: onSectionSettings,
                icon: FeatherIcons.list,
              ),
              // ToolbarButton(
              //   text: 'Compartilhar',
              //   onPressed: onShareTap,
              //   icon: FeatherIcons.share2,
              // ),
              ToolbarButton(
                text: 'Zoom +',
                onPressed: onZoomInTap,
                icon: FeatherIcons.zoomIn,
              ),
              ToolbarButton(
                text: 'Zoom -',
                onPressed: onZoomOutTap,
                icon: FeatherIcons.zoomOut,
              ),
              ToolbarButton(
                text: context.l10n.delete,
                onPressed: onDeleteTap,
                icon: FeatherIcons.trash2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
