import 'package:flutter/material.dart';

import 'field_validator.dart';

class MultiValidator<T> extends FieldValidator<T> {
  final List<FieldValidator> validators;
  static String _errorText = '';
  final VoidCallback? onError;

  MultiValidator(this.validators, {this.onError}) : super(_errorText);

  @override
  bool isValid(T value) {
    for (FieldValidator validator in validators) {
      if (validator.call(value) != null) {
        _errorText = validator.errorText;
        onError?.call();
        return false;
      }
    }
    return true;
  }

  @override
  String? call(dynamic value) {
    if (isValid(value)) return null;
    return _errorText;
  }
}
