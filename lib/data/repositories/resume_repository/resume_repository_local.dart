import 'package:cv_builder/data/services/local/local_service.dart';
import 'package:cv_builder/domain/models/resume.dart';
import 'package:result_dart/result_dart.dart';

import '../../models/resume.dart';
import 'resume_respository.dart';

class ResumeRepositoryLocal implements ResumeRepository {
  ResumeRepositoryLocal({required LocalService sharedPrefService}) : _sharedPrefService = sharedPrefService;

  final LocalService _sharedPrefService;

  @override
  AsyncResult<Resume> getResume(String id) async {
    final result = await _sharedPrefService.getResume(id);

    return result.fold(
      (resume) {
        final resumeModel = ResumeModel.fromJson(resume);
        return Success(resumeModel.toDomain());
      },
      (error) => Failure(error),
    );
  }

  @override
  AsyncResult<void> saveResume(Resume resume) async {
    try {
      final resumeModel = ResumeModel.fromDomain(resume);
      _sharedPrefService.saveResume(resumeModel.toJson());
      return const Success('OK');
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
