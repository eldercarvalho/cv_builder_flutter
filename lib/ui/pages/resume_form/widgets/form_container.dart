import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../shared/extensions/extensions.dart';

class FormContainer extends StatelessWidget {
  const FormContainer({
    super.key,
    this.title,
    required this.fields,
    required this.bottom,
    this.showPreviewButton = false,
    this.showAddButton = false,
    this.onPreviewButtonPressed,
    this.spacing = 16,
    this.onAddPressed,
  });

  final List<Widget> fields;
  final Widget? title;
  final Widget bottom;
  final bool showPreviewButton;
  final bool showAddButton;
  final double spacing;
  final Function()? onPreviewButtonPressed;
  final Function()? onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: title,
                    ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 10),
                        child: Column(
                          spacing: spacing,
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: fields,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: showPreviewButton,
                child: Positioned(
                  top: 0,
                  right: 16,
                  child: GestureDetector(
                    onTap: onPreviewButtonPressed,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.colors.primary),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.shadow.withValues(alpha: 0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        FeatherIcons.eye,
                        size: 28,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showAddButton,
                child: Positioned(
                  bottom: 12,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: onAddPressed,
                    shape: const CircleBorder(),
                    child: const Icon(FeatherIcons.plus),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottom,
      ],
    );
  }
}
