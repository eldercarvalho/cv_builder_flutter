import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CbTextFormField extends StatelessWidget {
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
  final Function()? onTap;

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
          controller: controller,
          focusNode: focusNode,
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          obscureText: obscured,
          // onEditingComplete: ,
          decoration: InputDecoration(
            label: label != null ? Text(label!, style: context.textTheme.labelMedium?.copyWith(fontSize: 16)) : null,
            hintText: hint,
            prefixIcon: prefix,
            suffixIcon: suffix,
            errorStyle: TextStyle(fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}
