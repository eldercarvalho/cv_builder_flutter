typedef FormFieldValidator<T> = String? Function(T? value);

abstract class FieldValidator<T> {
  final String errorText;

  FieldValidator(this.errorText);

  bool isValid(T value);

  String? call(T value) => isValid(value) ? null : errorText;
}
