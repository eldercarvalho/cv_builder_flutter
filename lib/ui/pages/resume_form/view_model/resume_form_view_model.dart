import 'dart:io';

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
    generatePdf = Command0(_generatePdf);
  }

  late final AuthRepository _authRepository;
  late final ResumeRepository _resumeRepository;
  late final Command1<Unit, bool> saveResume;
  late final Command0<File> generatePdf;

  Resume _resume = Resume.empty();
  Resume get resume => _resume;
  set resume(Resume value) {
    _resume = value;
    notifyListeners();
  }

  Resume _previewResume = Resume.empty();
  Resume get previreResume => _previewResume;
  set previewResume(Resume value) {
    _previewResume = value;
    notifyListeners();
  }

  File? _resumePdfFile;
  File? get resumePdfFile => _resumePdfFile;

  AsyncResult<Unit> _saveResume(bool isEditing) async {
    return _authRepository //
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.saveResume(
            userId: user.id, resume: _resume.copyWith(updatedAt: isEditing ? DateTime.now() : null)));
  }

  AsyncResult<File> _generatePdf() async {
    return _resumeRepository.getPdf(resume: _previewResume).fold(
      (pdf) {
        _resumePdfFile = pdf;
        notifyListeners();
        return Success(pdf);
      },
      (e) => Failure(e),
    );
  }
}
