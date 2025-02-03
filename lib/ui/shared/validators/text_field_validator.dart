import 'field_validator.dart';

abstract class TextFieldValidator extends FieldValidator<String?> {
  final bool? validateIf;

  TextFieldValidator(super.errorText, this.validateIf);

  bool get ignoreEmptyValues => true;

  @override
  String? call(String? value) {
    if (validateIf != null && !validateIf!) {
      return null;
    }

    return (ignoreEmptyValues && value!.isEmpty) ? null : super.call(value);
  }

  bool hasMatch(String pattern, String input, {bool caseSensitive = true}) =>
      RegExp(pattern, caseSensitive: caseSensitive).hasMatch(input);
}
