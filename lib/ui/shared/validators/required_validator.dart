import 'text_field_validator.dart';

class RequiredValidator extends TextFieldValidator {
  RequiredValidator({
    required String errorText,
    bool? validateIf,
  }) : super(errorText, validateIf);
  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(String? value) => value != null && value.trim().isNotEmpty;
}
