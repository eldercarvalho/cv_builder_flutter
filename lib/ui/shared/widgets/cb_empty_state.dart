import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../shared/extensions/extensions.dart';
import 'cb_button.dart';

class CbEmptyState extends StatelessWidget {
  const CbEmptyState({
    super.key,
    required this.message,
    required this.buttonText,
    this.imagePath,
    this.buttonIcon,
    this.onPressed,
  });

  final String message;
  final String? imagePath;
  final String buttonText;
  final IconData? buttonIcon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Opacity(
                opacity: 0.7,
                child: SvgPicture.asset(
                  imagePath!,
                  width: 180,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              message,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: CbButton(
                onPressed: () => onPressed?.call(),
                text: buttonText,
                type: CbButtonType.outlined,
                prefixIcon: buttonIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
