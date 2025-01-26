import 'text_field_validator.dart';

class MaxLengthValidator extends TextFieldValidator {
  final int max;

  MaxLengthValidator({
    required this.max,
    required String errorText,
    bool? validatedIf,
  }) : super(errorText, validatedIf);

  @override
  bool isValid(String? value) => value!.length <= max;
}
