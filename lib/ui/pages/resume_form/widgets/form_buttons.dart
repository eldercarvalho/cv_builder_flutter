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
    this.showSaveButton = false,
  });

  final Function() onNextPressed;
  final String? nextText;
  final String? previousText;
  final Function()? onPreviousPressed;
  final Function()? onPassPressed;
  final bool showIcons;
  final IconData? nextIcon;
  final bool isLoading;
  final bool showSaveButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(
          top: BorderSide(color: context.colors.outline),
        ),
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
              spacing: 20,
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
          if (onPassPressed != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: TextButton(
                onPressed: onPassPressed,
                child: const Text('Pular'),
              ),
            ),
        ],
      ),
    );
  }
}
