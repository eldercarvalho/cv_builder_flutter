import 'dart:convert';
import 'dart:io';

void main() {
  try {
    final file = File('android/upload-keystore.jks');
    final bytes = file.readAsBytesSync();
    final base64String = base64.encode(bytes);
    print(base64String);
  } catch (e) {
    print('Erro ao converter: $e');
  }
}
