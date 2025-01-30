import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:result_dart/result_dart.dart';

class FileService {
  AsyncResult<File> savePdf({
    required String name,
    required Uint8List bytes,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name.pdf');
      await file.writeAsBytes(bytes);
      return Success(file);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<File> getPdf({required String name}) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name.pdf');
      return Success(file);
    } on Exception catch (e) {
      return Failure(e);
    }
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

  AsyncResult<File> saveTempImage({
    required String name,
    required Uint8List bytes,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$name.png');
      await file.writeAsBytes(bytes);
      return Success(file);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<File> getImage({required String name}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name.png');
    return file;
  }
}
