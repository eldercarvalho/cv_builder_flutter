import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

import 'cb_text_form_field.dart';

class CbDatePicker extends StatefulWidget {
  const CbDatePicker({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.required = false,
    this.validator,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool required;
  final String? Function(String?)? validator;

  @override
  State<CbDatePicker> createState() => _CbDatePickerState();
}

class _CbDatePickerState extends State<CbDatePicker> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CbTextFormField(
      controller: _controller,
      label: widget.label,
      hint: widget.hint,
      readOnly: true,
      required: widget.required,
      validator: widget.validator,
      suffix: Icon(FeatherIcons.calendar, color: context.colors.primary),
      onTap: () => _selectDate(context),
    );
  }
}
