import 'package:flutter/material.dart';

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
    this.minLines,
    this.suffix,
    this.prefix,
    this.required = false,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final String? label;
  final String? hint;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final Widget? suffix;
  final Widget? prefix;
  final bool required;
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
          autovalidateMode: autovalidateMode,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          maxLines: maxLines,
          minLines: minLines,
          decoration: InputDecoration(
            label: label != null ? Text(label!) : null,
            hintText: hint,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
