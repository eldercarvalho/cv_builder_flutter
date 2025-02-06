import 'package:cv_builder/ui/shared/extensions/extensions.dart';
import 'package:cv_builder/ui/shared/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:intl/intl.dart';

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
  DateTime date = DateTime(2016, 10, 26);

  @override
  initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
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
              // CbButton(
              //   text: 'OK',
              //   onPressed: () => Navigator.of(context).pop(),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(1960),
  //     lastDate: DateTime.now(),
  //   );

  //   if (pickedDate != null && pickedDate != _selectedDate) {
  //     setState(() {
  //       _selectedDate = pickedDate;
  //       _controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
  //     });
  //   }
  // }

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
