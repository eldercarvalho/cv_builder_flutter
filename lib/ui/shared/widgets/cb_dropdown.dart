import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Option {
  final String value;
  final String text;

  Option({required this.value, required this.text});
}

class CbDropdown extends StatefulWidget {
  const CbDropdown({
    super.key,
    this.labelText,
    required this.options,
    required this.onChanged,
    this.loading = false,
    this.initialValue,
    this.disabled = false,
    this.buildItem,
    this.validator,
  });

  final String? labelText;
  final bool loading;
  final String? initialValue;
  final bool disabled;
  final List<Option> options;
  final Function(String value) onChanged;
  final Widget Function(String value)? buildItem;
  final String? Function(String?)? validator;

  @override
  State<CbDropdown> createState() => _CbDropdownState();
}

class _CbDropdownState extends State<CbDropdown> {
  String? _value;

  @override
  void initState() {
    _checkInitialValue();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CbDropdown oldWidget) {
    if (widget.options.length != oldWidget.options.length && widget.options.isNotEmpty) {
      _checkInitialValue();
    }

    if (widget.initialValue != oldWidget.initialValue) {
      _checkInitialValue();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.disabled ? 0.5 : 1,
      child: DropdownButtonFormField(
        validator: widget.validator,
        items: List.generate(widget.options.length, (index) {
          final option = widget.options[index];
          return DropdownMenuItem(
            value: option.value,
            child: widget.buildItem != null ? widget.buildItem!(option.text) : Text(option.text),
          );
        }),
        onChanged: !widget.disabled ? _onChanged : null,
        value: _value,
        icon: widget.loading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(),
              )
            : Icon(
                FeatherIcons.chevronDown,
                size: 24,
                color: context.colors.onSurface,
              ),
        style: context.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: context.textTheme.labelMedium,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colors.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        menuMaxHeight: 400,
      ),
    );
  }

  void _onChanged(Object? value) {
    setState(() => _value = value as String);
    widget.onChanged(value as String);
  }

  void _checkInitialValue() {
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      setState(() => _value = widget.initialValue!);
    }
    //  else if (widget.options.isNotEmpty) {
    //   setState(() => _value = widget.options.first.value);
    // } else {
    //   _value = null;
    // }
  }
}
