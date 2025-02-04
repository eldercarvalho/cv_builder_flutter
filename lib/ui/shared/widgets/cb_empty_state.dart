import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';

import '../../shared/extensions/extensions.dart';
import 'cb_button.dart';

class CbEmptyState extends StatelessWidget {
  const CbEmptyState({
    super.key,
    required this.message,
    required this.imagePath,
    required this.buttonText,
    this.onPressed,
  });

  final String message;
  final String imagePath;
  final String buttonText;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.7,
              child: SvgPicture.asset(
                imagePath,
                width: 180,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: CbButton(
                  onPressed: () => onPressed?.call(),
                  text: buttonText,
                  type: CbButtonType.outlined,
                  prefixIcon: FeatherIcons.plus,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
