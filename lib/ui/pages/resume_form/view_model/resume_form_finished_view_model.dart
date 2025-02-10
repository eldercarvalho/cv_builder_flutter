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
    downloadResume = Command1(_downloadResume);
  }

  late final ResumeRepository _resumeRepository;
  late final AuthRepository _authRepository;
  late final Command1<Unit, Resume> downloadResume;

  AsyncResult<Unit> _downloadResume(Resume resume) async {
    _authRepository.currentUser;
    _resumeRepository.saveResume(userId: '1', resume: resume);
    // final bytes = await resume.toPdf();
    // await _fileService.savePdf(name: resume.id, bytes: bytes);
    return const Success(unit);
  }
}
