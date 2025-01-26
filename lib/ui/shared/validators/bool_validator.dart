import 'field_validator.dart';

class BoolFieldValidator extends FieldValidator<bool?> {
  final bool? validateIf;

  BoolFieldValidator({
    required String errorText,
    bool this.validateIf = false,
  }) : super(errorText);

  @override
  String? call(bool? value) {
    if (validateIf != null && !validateIf!) {
      return null;
    }
    return (value != null && value) ? null : super.call(value);
  }

  @override
  bool isValid(bool? value) => value ?? false;
}
