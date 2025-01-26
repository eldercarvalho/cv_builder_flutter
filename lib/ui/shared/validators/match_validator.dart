class MatchValidator {
  final String errorText;
  final bool? validateIf;

  MatchValidator({required this.errorText, this.validateIf});

  String? validateMatch(String? value, String? valueToMatch) {
    if (validateIf != null && !validateIf!) return null;

    return value == valueToMatch ? null : errorText;
  }
}
