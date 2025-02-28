import 'package:cv_builder/ui/shared/extensions/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../shared/widgets/cb_button.dart';

class FormButtons extends StatelessWidget {
  const FormButtons({
    super.key,
    required this.onNextPressed,
    this.onPreviousPressed,
    this.onPassPressed,
    this.nextText,
    this.showIcons = false,
    this.previousText,
    this.nextIcon,
    this.isLoading = false,
    this.isEditing = false,
    this.showSaveButton = false,
    this.shrink = false,
    this.step,
  });

  final Function() onNextPressed;
  final String? nextText;
  final String? previousText;
  final Function()? onPreviousPressed;
  final Function()? onPassPressed;
  final bool showIcons;
  final IconData? nextIcon;
  final bool isLoading;
  final bool isEditing;
  final bool showSaveButton;
  final bool shrink;
  final int? step;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: shrink ? const EdgeInsets.symmetric(horizontal: 16, vertical: 6) : const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.surface,
              // border: Border(
              //   top: BorderSide(color: context.colors.outline),
              // ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colors.shadow.withValues(alpha: 0.2),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              children: [
                Visibility(
                  visible: showSaveButton,
                  child: CbButton(
                    onPressed: onNextPressed,
                    text: context.l10n.save,
                    isLoading: isLoading,
                  ),
                ),
                Visibility(
                  visible: !showSaveButton,
                  child: Row(
                    spacing: 16,
                    children: [
                      if (onPreviousPressed != null)
                        Expanded(
                          child: CbButton(
                            onPressed: onPreviousPressed!,
                            text: previousText ?? context.l10n.cancel,
                            prefixIcon: showIcons ? FeatherIcons.chevronLeft : null,
                            type: CbButtonType.outlined,
                          ),
                        ),
                      Expanded(
                        child: CbButton(
                          onPressed: onNextPressed,
                          text: nextText ?? context.l10n.next,
                          suffixIcon: showIcons ? nextIcon ?? FeatherIcons.chevronRight : null,
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: step != null && !isEditing,
            child: Transform.translate(
              offset: const Offset(0, -46),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.shadow.withValues(alpha: 0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    '$step ${context.l10n.outOf} 11',
                    style: context.textTheme.labelLarge?.copyWith(color: context.colors.secondary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
