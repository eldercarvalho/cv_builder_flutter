import 'dart:io';

import 'package:cv_builder/domain/models/resume.dart';
import 'package:result_dart/result_dart.dart';

abstract class ResumeRepository {
  AsyncResult<Resume> getResume({required String userId, required String resumeId});
  AsyncResult<List<Resume>> getResumes({required String userId});
  AsyncResult<Unit> saveResume({required String userId, required Resume resume});
  AsyncResult<File> getPdf({required String resumeId});
  AsyncResult<Unit> deleteResume({required String userId, required Resume resume});
}
