import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../../data/repositories/resume_repository/resume_respository.dart';
import '../../../../domain/models/resume.dart';
import '../../../../utils/command.dart';

class ResumeFormFinishedViewModel extends ChangeNotifier {
  ResumeFormFinishedViewModel({
    required ResumeRepository resumeRepository,
    required AuthRepository authRepository,
  }) {
    _resumeRepository = resumeRepository;
    _authRepository = authRepository;
    saveResume = Command1(_saveResume);
  }

  late final ResumeRepository _resumeRepository;
  late final AuthRepository _authRepository;
  late final Command1<Unit, Resume> saveResume;

  AsyncResult<Unit> _saveResume(Resume resume) async {
    final updatedResume = resume.copyWith(updatedAt: DateTime.now());
    return _authRepository //
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.saveResume(userId: user.id, resume: updatedResume))
        .fold((_) => const Success(unit), (error) => Failure(error));
  }
}
