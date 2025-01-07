import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FileService {
  Future<File> savePdf({
    required String name,
    required Uint8List bytes,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<File> getPdf({required String name}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.pdf');
    return file;
  }

  Future<File> saveImage({
    required String name,
    required Uint8List bytes,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<File> getImage({required String name}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.png');
    return file;
  }
}
