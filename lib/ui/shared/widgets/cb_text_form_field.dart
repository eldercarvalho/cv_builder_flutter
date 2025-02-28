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
  final Function()? onTap;

  @override
  State<CbTextFormField> createState() => _CbTextFormFieldState();
}

class _CbTextFormFieldState extends State<CbTextFormField> {
  bool _isObscured = false;

  @override
  void initState() {
    _isObscured = widget.obscured;
    super.initState();
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
          // onEditingComplete: ,
          decoration: InputDecoration(
            label: widget.label != null
                ? Text(widget.label!, style: context.textTheme.labelMedium?.copyWith(fontSize: 16))
                : null,
            hintText: widget.hint,
            prefixIcon: widget.prefix,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.prefix != null) widget.prefix!,
                Visibility(
                  visible: widget.obscured,
                  child: GestureDetector(
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
                ),
              ],
            ),
            errorStyle: TextStyle(fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}
