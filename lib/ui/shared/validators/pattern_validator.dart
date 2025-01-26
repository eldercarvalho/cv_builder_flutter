import 'text_field_validator.dart';

class PatternValidator extends TextFieldValidator {
  final String pattern;

  PatternValidator({
    required this.pattern,
    required String errorText,
    bool? validatedIf,
  }) : super(
          errorText,
          validatedIf,
        );

  @override
  bool isValid(String? value) => hasMatch(pattern, value!);
}
