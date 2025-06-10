import 'package:flutter/services.dart';

class MaskFormatter extends TextInputFormatter {
  final List<String> _masks;
  String _currentMask;

  MaskFormatter({required List<String> masks}) : _masks = masks, _currentMask = masks.first;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    _updateCurrentMask(newValue.text);
    return TextEditingValue(text: _applyMask(newValue.text));
  }

  void _updateCurrentMask(String value) {
    String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');

    for (String mask in _masks) {
      int maskDigits = mask.replaceAll(RegExp(r'[^#]'), '').length;
      if (cleanValue.length <= maskDigits) {
        _currentMask = mask;
        break;
      }
    }
  }

  String _applyMask(String value) {
    if (value.isEmpty) return '';

    String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    StringBuffer maskedValue = StringBuffer();
    int valueIndex = 0;

    for (int i = 0; i < _currentMask.length && valueIndex < cleanValue.length; i++) {
      if (_currentMask[i] == '#') {
        maskedValue.write(cleanValue[valueIndex]);
        valueIndex++;
      } else {
        maskedValue.write(_currentMask[i]);
      }
    }

    return maskedValue.toString();
  }

  String maskText(String value) {
    return _applyMask(value);
  }

  String unmaskText(String value) {
    return value.replaceAll(RegExp(r'[^\d]'), '');
  }

  void clear() {
    _currentMask = _masks.first;
  }
}
