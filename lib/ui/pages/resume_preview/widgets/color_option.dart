import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';

import 'color_preview.dart';

class ColorOption extends StatelessWidget {
  const ColorOption({
    super.key,
    required this.value,
    required this.defaultValue,
    required this.text,
    required this.onChanged,
  });

  final Color value;
  final Color defaultValue;
  final String text;
  final Function(Color) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showColorPicker(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ColorPreview(color: value),
          const SizedBox(height: 6),
          Text(text, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        final colors = [
          Colors.white,
          Colors.grey.shade300,
          Colors.grey,
          Colors.grey.shade800,
          Colors.black,
          Colors.brown,
          const Color(0xFF87CEEB),
          const Color(0xFFB0E0E6),
          Colors.cyan,
          Colors.lightBlue,
          Colors.blueAccent,
          Colors.blue,
          Colors.indigo,
          Colors.greenAccent,
          Colors.lightGreen,
          Colors.teal,
          Colors.green,
          Colors.lime,
          Colors.yellow,
          Colors.amber,
          Colors.orange,
          Colors.red,
          const Color(0xFFFFC0CB),
          Colors.pinkAccent,
          Colors.pink,
          Colors.purple,
        ];

        return Container(
          width: context.screenHeight,
          height: context.screenHeight * 0.5,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.defaultColor, style: context.textTheme.titleMedium),
              const SizedBox(height: 16),
              ColorPreview(
                color: defaultValue,
                selected: value.toHex() == defaultValue.toHex(),
                onTap: () => _onChangeColor(context, defaultValue),
              ),
              const SizedBox(height: 16),
              const Divider(),
              // const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: colors.map((color) {
                          return ColorPreview(
                            color: color,
                            selected: value.toHex() == color.toHex(),
                            onTap: () => _onChangeColor(context, color),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onChangeColor(BuildContext context, Color color) {
    onChanged(color);
    Navigator.of(context).pop();
  }
}
