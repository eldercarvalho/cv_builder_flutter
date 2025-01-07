import 'package:cv_builder/domain/models/resume.dart';
import 'package:result_dart/result_dart.dart';

abstract class ResumeRepository {
  AsyncResult<Resume> getResume(String id);
  AsyncResult<void> saveResume(Resume resume);
}
