import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../../data/repositories/resume_repository/resume_respository.dart';
import '../../../../domain/models/resume.dart';
import '../../../../utils/command.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required AuthRepository authRepository,
    required ResumeRepository resumeRepository,
  }) {
    _authRepository = authRepository;
    _resumeRepository = resumeRepository;
    getResumes = Command0(_getResumes);
    deleteResume = Command1(_deleteResume);
  }

  late final AuthRepository _authRepository;
  late final ResumeRepository _resumeRepository;

  late final Command0 getResumes;
  late final Command1<Unit, Resume> deleteResume;

  List<Resume> _resumes = [];
  List<Resume> get resumes => _resumes;

  Future<void> saveResume() async {
    await _authRepository.getCurrentUser().flatMap((user) async {
      final resume = Resume.fake();
      await _resumeRepository.saveResume(userId: user.id, resume: resume);
      return const Success(unit);
    });
    // try {
    //   final id = await _localService.getGuestId();
    //   Resume resume = Resume.fake();
    //   final pdfBytes = await SimpleResumeTemplate.generatePdf(resume);
    //   final imageBytes = await SimpleResumeTemplate.generateThumbnail(pdfBytes);

    //   final thumbnailFile = await _fileService.saveTempImage(name: resume.id, bytes: imageBytes);
    //   final thumbnailUrl = await _remoteService.saveThumbnail(id!, resume.id, thumbnailFile);
    //   resume = resume.copyWith(thumbnail: thumbnailUrl);

    //   await _remoteService.saveResume(id, resume);
    //   await _fileService.savePdf(name: resume.id, bytes: pdfBytes);
    // } catch (e) {
    //   _log.severe('Error saving resume', e);
    // }
  }

  AsyncResult<List<Resume>> _getResumes() async {
    final result = await _authRepository //
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.getResumes(userId: user.id));

    return result.fold(
      (resumes) {
        _resumes = resumes;
        notifyListeners();
        return Success(resumes);
      },
      (error) => Failure(error),
    );
  }

  AsyncResult<Unit> _deleteResume(Resume resume) async {
    final result = _authRepository //
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.deleteResume(userId: user.id, resume: resume));

    return result.fold(
      (_) => const Success(unit),
      (error) => Failure(error),
    );
  }

  AsyncResult<Unit> logout() async {
    final result = await _authRepository.logout();
    return result.fold(
      (_) => const Success(unit),
      (error) => Failure(error),
    );
  }
}
