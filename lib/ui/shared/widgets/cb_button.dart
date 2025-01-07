import 'package:flutter/material.dart';

class CbButton extends StatefulWidget {
  const CbButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final Function() onPressed;
  final String text;

  @override
  State<CbButton> createState() => _CbButtonState();
}

class _CbButtonState extends State<CbButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: FilledButton(
        onPressed: widget.onPressed,
        child: Text(widget.text),
      ),
    );
  }
}
