import 'dart:io';

import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../../data/repositories/resume_repository/resume_respository.dart';
import '../../../../domain/models/resume.dart';
import '../../../../utils/command.dart';

class ResumePreviewViewModel extends ChangeNotifier {
  ResumePreviewViewModel({
    required AuthRepository authRepository,
    required ResumeRepository resumeRepository,
  })  : _authRepository = authRepository,
        _resumeRepository = resumeRepository;

  late final AuthRepository _authRepository;
  late final ResumeRepository _resumeRepository;
  late final Command1<Unit, String> getResume = Command1(_getResume);
  late final Command0<Unit> deleteResume = Command0(_deleteResume);
  late final Command0<Unit> reloadResume = Command0(_reloadResume);
  late final Command0<Unit> updateResume = Command0(_updateResume);

  Resume? _resume;
  Resume? get resume => _resume;
  set resume(Resume? value) {
    _resume = value;
    notifyListeners();
  }

  File? _resumePdf;
  File? get resumePdf => _resumePdf;

  AsyncResult<Unit> _reloadResume() async {
    return _authRepository
        .getCurrentUser()
        .map((user) => Resume.fake().copyWith(resumeName: 'Teste', resumeLanguage: ResumeLanguage.pt).toPdf())
        .flatMap((pdfBytes) => _resumeRepository.savePdf(resumeId: _resume!.id, bytes: pdfBytes))
        .flatMap(_onGetResumePdf);
  }

  AsyncResult<Unit> _getResume(String resumeId) async {
    return _authRepository
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.getResume(userId: user.id, resumeId: resumeId))
        .flatMap(_onGetResume)
        .map((resume) => resume.toPdf())
        .flatMap((pdfBytes) => _resumeRepository.savePdf(resumeId: resumeId, bytes: pdfBytes))
        .flatMap(_onGetResumePdf)
        .fold((_) => const Success(unit), (error) => Failure(error));
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

  AsyncResult<Unit> _deleteResume() async {
    return _authRepository
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.deleteResume(userId: user.id, resume: _resume!))
        .fold((_) => const Success(unit), (error) => Failure(error));
  }

  AsyncResult<Unit> _updateResume() async {
    return _authRepository
        .getCurrentUser()
        .map((user) => _resumeRepository.saveResume(userId: user.id, resume: _resume!))
        .fold((_) => const Success(unit), (error) => Failure(error));
  }

  AsyncResult<Unit> updateTheme(ResumeTheme theme) async {
    return _onGetResume(_resume!.copyWith(theme: theme))
        .map((resume) => resume.toPdf())
        .flatMap((bytes) => _resumeRepository.savePdf(resumeId: _resume!.id, bytes: bytes))
        .flatMap(_onGetResumePdf);
  }
}
