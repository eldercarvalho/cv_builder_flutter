import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum CbButtonType {
  filled,
  outlined,
}

class CbButton extends StatefulWidget {
  const CbButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.suffixIcon,
    this.prefixIcon,
    this.type = CbButtonType.filled,
    this.isLoading = false,
    this.disabled = false,
  });

  final Function() onPressed;
  final String text;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final CbButtonType type;
  final bool isLoading;
  final bool disabled;

  @override
  State<CbButton> createState() => _CbButtonState();
}

class _CbButtonState extends State<CbButton> {
  @override
  Widget build(BuildContext context) {
    final child = widget.isLoading
        ? SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(color: context.colors.onPrimary, strokeWidth: 2),
          )
        : _buildChild();

    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: switch (widget.type) {
        CbButtonType.filled => FilledButton(
            onPressed: widget.disabled ? null : widget.onPressed,
            child: child,
          ),
        CbButtonType.outlined => OutlinedButton(
            onPressed: widget.disabled ? null : widget.onPressed,
            child: child,
          ),
      },
    );
  }

  Widget _buildChild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6,
      children: [
        if (widget.prefixIcon != null) Icon(widget.prefixIcon!, size: 24),
        Flexible(
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 16.sp, height: 1),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (widget.suffixIcon != null) Icon(widget.suffixIcon!, size: 24),
      ],
    );
  }
}
