import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CbTextFormField extends StatefulWidget {
  const CbTextFormField({
    super.key,
    this.initialValue,
    this.validator,
    this.controller,
    this.label,
    this.onTap,
    this.readOnly = false,
    this.hint,
    this.maxLines,
    this.minLines = 1,
    this.suffix,
    this.prefix,
    this.required = false,
    this.obscured = false,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.focusNode,
    this.textCapitalization = TextCapitalization.sentences,
    this.keyboardType,
    this.showClearButton = true,
    this.onClear,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final String? label;
  final String? hint;
  final bool readOnly;
  final int? maxLines;
  final int minLines;
  final Widget? suffix;
  final Widget? prefix;
  final bool required;
  final bool obscured;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final Function()? onClear;
  final bool showClearButton;

  @override
  State<CbTextFormField> createState() => _CbTextFormFieldState();
}

class _CbTextFormFieldState extends State<CbTextFormField> {
  bool _isObscured = false;
  bool _isFilled = false;

  @override
  void initState() {
    _isObscured = widget.obscured;
    _isFilled = widget.controller?.text.isNotEmpty ?? false;
    widget.controller?.addListener(_onType);
    super.initState();
  }

  void _onType() {
    setState(() {
      _isFilled = widget.controller?.text.isNotEmpty ?? false;
    });
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onType);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // if (label != null)
        //   Row(
        //     children: [
        //       Text(label!, style: context.textTheme.labelLarge),
        //       if (required) Text('*', style: context.textTheme.labelLarge?.copyWith(color: context.colors.error)),
        //     ],
        //   ),
        // const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textCapitalization: widget.textCapitalization,
          autovalidateMode: widget.autovalidateMode,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          validator: widget.validator,
          obscureText: _isObscured,
          keyboardType: widget.keyboardType,
          // onEditingComplete: ,
          decoration: InputDecoration(
            label: widget.label != null
                ? Text(widget.label!, style: context.textTheme.labelMedium?.copyWith(fontSize: 16))
                : null,
            hintText: widget.hint,
            prefixIcon: widget.prefix,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_isFilled && widget.showClearButton)
                    GestureDetector(
                      onTap: () {
                        widget.controller?.clear();
                        widget.onClear?.call();
                        setState(() => _isFilled = false);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: widget.suffix != null || widget.obscured ? 16 : 0),
                        child: Icon(
                          Icons.cancel_outlined,
                          size: 24.sp,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  if (widget.suffix != null) widget.suffix!,
                  if (widget.obscured)
                    GestureDetector(
                      onTap: () => setState(() => _isObscured = !_isObscured),
                      child: _isObscured
                          ? Icon(
                              FeatherIcons.eye,
                              size: 24.sp,
                              color: context.colors.primary,
                            )
                          : Icon(
                              FeatherIcons.eyeOff,
                              size: 24.sp,
                              color: context.colors.primary,
                            ),
                    ),
                ],
              ),
            ),
            errorStyle: TextStyle(fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}
