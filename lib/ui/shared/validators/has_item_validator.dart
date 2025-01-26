import 'field_validator.dart';

class HasItemValidator extends FieldValidator<List<String>?> {
  final bool? validateIf;

  HasItemValidator({
    required String errorText,
    bool this.validateIf = false,
  }) : super(errorText);

  @override
  String? call(List<String>? value) {
    if (validateIf != null && !validateIf!) {
      return null;
    }
    return (value != null && value.isNotEmpty) ? null : super.call(value);
  }

  @override
  bool isValid(List<String>? value) => value != null && value.isNotEmpty;
}
