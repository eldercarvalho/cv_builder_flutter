import 'dart:io';

import 'package:cv_builder/domain/models/resume.dart';
import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

abstract class ResumeRepository extends ChangeNotifier {
  List<Resume> get resumes;
  AsyncResult<Resume> getResume({required String userId, required String resumeId});
  AsyncResult<List<Resume>> getResumes({required String userId});
  AsyncResult<Unit> saveResume({required String userId, required Resume resume});
  AsyncResult<File> getPdf({required Resume resume});
  AsyncResult<Unit> deleteResume({required String userId, required Resume resume});
  AsyncResult<Unit> deleteResumes({required String userId});
  AsyncResult<File> savePdf({required String resumeId, required Uint8List bytes});
  AsyncResult<File> exportResume({required Resume resume});
}
