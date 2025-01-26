import 'text_field_validator.dart';

class MinLengthValidator extends TextFieldValidator {
  final int min;

  MinLengthValidator({
    required this.min,
    required String errorText,
    bool? validatedIf,
  }) : super(errorText, validatedIf);

  @override
  bool isValid(String? value) => value!.trim().length >= min;
}
