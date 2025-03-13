import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:cv_builder/ui/shared/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CbDatePicker extends StatefulWidget {
  const CbDatePicker({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.required = false,
    this.validator,
    this.onClear,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool required;
  final Function()? onClear;
  final String? Function(String?)? validator;

  @override
  State<CbDatePicker> createState() => _CbDatePickerState();
}

class _CbDatePickerState extends State<CbDatePicker> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;
  DateTime date = DateTime(2016, 10, 26);

  @override
  initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _selectedDate = _controller.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_controller.text) : null;
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(child: child),
              SafeArea(
                top: false,
                child: TextButton(
                  child: Text(context.l10n.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      // suffix: Icon(FeatherIcons.calendar, color: context.colors.primary),
      onClear: () {
        widget.onClear?.call();
        setState(() {
          _selectedDate = null;
        });
      },
      onTap: () => _showDialog(
        CupertinoDatePicker(
          initialDateTime: _selectedDate ?? DateTime.now(),
          maximumYear: DateTime.now().year,
          mode: CupertinoDatePickerMode.date,
          use24hFormat: true,
          showDayOfWeek: false,
          dateOrder: DatePickerDateOrder.dmy,
          onDateTimeChanged: (DateTime newDate) {
            if (newDate != _selectedDate) {
              setState(() {
                _selectedDate = newDate;
                _controller.text = DateFormat('dd/MM/yyyy').format(newDate);
              });
            }
          },
        ),
      ),
    );
  }
}
