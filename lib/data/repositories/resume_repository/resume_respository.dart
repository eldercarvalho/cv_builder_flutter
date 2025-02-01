import 'dart:io';
import 'dart:typed_data';

import 'package:cv_builder/domain/models/resume.dart';
import 'package:result_dart/result_dart.dart';

abstract class ResumeRepository {
  AsyncResult<Resume> getResume({required String userId, required String resumeId});
  AsyncResult<List<Resume>> getResumes({required String userId});
  AsyncResult<Unit> saveResume({required String userId, required Resume resume});
  AsyncResult<File> getPdf({required Resume resume});
  AsyncResult<Unit> deleteResume({required String userId, required Resume resume});
  AsyncResult<File> savePdf({required String resumeId, required Uint8List bytes});
}
