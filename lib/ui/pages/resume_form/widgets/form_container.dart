import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class FormContainer extends StatelessWidget {
  const FormContainer({
    super.key,
    required this.fields,
    required this.bottom,
    this.showPreviewButton = false,
    this.onPreviewButtonPressed,
    this.spacing = 16,
  });

  final List<Widget> fields;
  final Widget bottom;
  final bool showPreviewButton;
  final double spacing;
  final Function()? onPreviewButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    spacing: spacing,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: fields,
                  ),
                ),
              ),
              Visibility(
                visible: showPreviewButton,
                child: Positioned(
                  bottom: 16,
                  right: 16,
                  child: IconButton.filled(
                    onPressed: onPreviewButtonPressed,
                    icon: const Icon(FeatherIcons.eye, size: 30),
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
