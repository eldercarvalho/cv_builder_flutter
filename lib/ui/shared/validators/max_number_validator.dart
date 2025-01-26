import 'text_field_validator.dart';

class MaxNumberValidator extends TextFieldValidator {
  final int max;

  MaxNumberValidator({
    required this.max,
    required String errorText,
    bool? validatedIf,
  }) : super(
          errorText,
          validatedIf,
        );

  @override
  bool isValid(String? value) => double.parse(value!) <= max;
}
