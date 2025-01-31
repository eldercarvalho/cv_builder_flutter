import 'dart:io';

import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../../data/repositories/resume_repository/resume_respository.dart';
import '../../../../domain/models/resume.dart';
import '../../../../utils/command.dart';
import '../../../shared/resume_models/simple/simple.dart';

class ResumePreviewViewModel extends ChangeNotifier {
  ResumePreviewViewModel({
    required AuthRepository authRepository,
    required ResumeRepository resumeRepository,
  })  : _authRepository = authRepository,
        _resumeRepository = resumeRepository;

  late final AuthRepository _authRepository;
  late final ResumeRepository _resumeRepository;
  late final Command1<Unit, String> getResume = Command1(_getResume);

  Resume? _resume;
  Resume? get resume => _resume;
  set resume(Resume? value) {
    _resume = value;
    notifyListeners();
  }

  File? _resumePdf;
  File? get resumePdf => _resumePdf;

  AsyncResult<Unit> _getResume(String resumeId) async {
    return _authRepository
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.getResume(userId: user.id, resumeId: resumeId))
        .flatMap(_onGetResume)
        .map((resume) => SimpleResumeTemplate.generatePdf(resume))
        .flatMap((pdfBytes) => _resumeRepository.savePdf(resumeId: resumeId, bytes: pdfBytes))
        .flatMap(_onGetResumePdf);
  }

  AsyncResult<Resume> _onGetResume(Resume resume) async {
    _resume = resume;
    notifyListeners();
    return Success(resume);
  }

  AsyncResult<Unit> _onGetResumePdf(File resumePdf) async {
    _resumePdf = resumePdf;
    notifyListeners();
    return const Success(unit);
  }
}
