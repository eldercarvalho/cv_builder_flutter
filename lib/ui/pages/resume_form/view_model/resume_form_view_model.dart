import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../../data/repositories/resume_repository/resume_respository.dart';
import '../../../../domain/models/resume.dart';
import '../../../../utils/command.dart';

class ResumeFormViewModel extends ChangeNotifier {
  ResumeFormViewModel({
    required AuthRepository authRepository,
    required ResumeRepository resumeRepository,
  }) {
    _authRepository = authRepository;
    _resumeRepository = resumeRepository;
    saveResume = Command1(_saveResume);
  }

  late final AuthRepository _authRepository;
  late final ResumeRepository _resumeRepository;
  late final Command1<Unit, bool> saveResume;

  Resume _resume = Resume.empty();
  Resume get resume => _resume;

  set resume(Resume value) {
    _resume = value;
    notifyListeners();
  }

  AsyncResult<Unit> _saveResume(bool isEditing) async {
    return _authRepository //
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.saveResume(
            userId: user.id, resume: _resume.copyWith(updatedAt: isEditing ? DateTime.now() : null)));
  }
}
