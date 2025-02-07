import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    this.themeColor,
  });

  final Function() onPressed;
  final String text;
  final dynamic suffixIcon;
  final dynamic prefixIcon;
  final CbButtonType type;
  final bool isLoading;
  final bool disabled;
  final Color? themeColor;

  @override
  State<CbButton> createState() => _CbButtonState();
}

class _CbButtonState extends State<CbButton> {
  Color get _loadingColor =>
      widget.type == CbButtonType.filled ? context.colors.onPrimary : widget.themeColor ?? context.colors.primary;

  @override
  Widget build(BuildContext context) {
    final child = widget.isLoading
        ? SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(color: _loadingColor, strokeWidth: 2),
          )
        : _buildChild();

    return SizedBox(
      width: double.maxFinite,
      height: 50,
      child: switch (widget.type) {
        CbButtonType.filled => FilledButton(
            onPressed: widget.disabled ? null : widget.onPressed,
            style: widget.themeColor != null
                ? ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(context.colors.error),
                  )
                : null,
            child: child,
          ),
        CbButtonType.outlined => OutlinedButton(
            onPressed: widget.disabled ? null : widget.onPressed,
            style: widget.themeColor != null
                ? OutlinedButton.styleFrom(
                    side: BorderSide(color: context.colors.error, width: 2),
                  )
                : null,
            child: child,
          ),
      },
    );
  }

  Widget _buildChild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        if (widget.prefixIcon != null && widget.prefixIcon is SvgPicture) widget.prefixIcon!,
        if (widget.prefixIcon != null && widget.prefixIcon is IconData)
          Icon(widget.prefixIcon!, size: 24, color: widget.themeColor),
        Flexible(
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 16.sp, height: 1, color: widget.themeColor),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (widget.suffixIcon != null && widget.suffixIcon is IconData)
          Icon(widget.suffixIcon!, size: 24, color: widget.themeColor),
      ],
    );
  }
}
