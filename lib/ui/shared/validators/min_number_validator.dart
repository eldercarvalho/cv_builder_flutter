import 'text_field_validator.dart';

class MinNumberValidator extends TextFieldValidator {
  final int min;

  MinNumberValidator({
    required this.min,
    required String errorText,
    bool? validatedIf,
  }) : super(
          errorText,
          validatedIf,
        );

  @override
  bool isValid(String? value) => double.parse(value!) >= min;
}
