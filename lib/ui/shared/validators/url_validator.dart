import 'package:cv_builder/ui/shared/validators/text_field_validator.dart';

class UrlValidator extends TextFieldValidator {
  UrlValidator({
    required String errorText,
    bool? validatedIf,
  }) : super(errorText, validatedIf);

  @override
  bool isValid(String? value) {
    if (value == null) {
      return false;
    }

    final uri = Uri.tryParse(value);
    if (uri == null) {
      return false;
    }

    return uri.isAbsolute;
  }
}
