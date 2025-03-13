import 'package:flutter/material.dart';

class ColorPreview extends StatelessWidget {
  const ColorPreview({
    super.key,
    required this.color,
    this.selected = false,
    this.onTap,
  });

  final Color color;
  final bool selected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
        child:
            selected ? Icon(Icons.check, color: color.computeLuminance() <= 0.5 ? Colors.white : Colors.black) : null,
      ),
    );
  }
}
