import 'dart:io';

import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../../data/services/api/remote_service.dart';
import '../../../../data/services/local/file_service.dart';
import '../../../../domain/models/resume.dart';
import '../../../../utils/command.dart';
import '../../../shared/resume_models/simple/simple.dart';

class ResumeFormViewModel extends ChangeNotifier {
  ResumeFormViewModel({
    required AuthRepository authRepository,
    required RemoteService remoteService,
    required FileService fileService,
  }) {
    _authRepository = authRepository;
    _remoteService = remoteService;
    _fileService = fileService;
    saveResume = Command0(_saveResume);
  }

  // late final ResumeRepository _resumeRepository;
  late final AuthRepository _authRepository;
  late final RemoteService _remoteService;
  late final FileService _fileService;
  late final Command0<Unit> saveResume;

  Resume _resume = Resume.empty();
  Resume get resume => _resume;

  set resume(Resume value) {
    _resume = value;
    notifyListeners();
  }

  AsyncResult<Unit> _saveResume() async {
    try {
      final userId = _authRepository.currentUser?.id;
      String? pictureUrl = _resume.photo;

      if (_resume.photo != null && !_resume.photo!.startsWith('https')) {
        pictureUrl = await _remoteService.savePicture(userId!, _resume.id, File(_resume.photo!));
      }

      Resume newResume = _resume.copyWith(photo: pictureUrl);

      final pdfBytes = await SimpleResumeTemplate.generatePdf(newResume);
      final thumbnailBytes = await SimpleResumeTemplate.generateThumbnail(pdfBytes);
      final thumbnailFile = await _fileService.saveTempImage(name: newResume.id, bytes: thumbnailBytes);
      final thumbnailUrl = await _remoteService.saveThumbnail(userId!, _resume.id, thumbnailFile);
      newResume = newResume.copyWith(thumbnail: thumbnailUrl);

      await _remoteService.saveResume(userId, newResume);
      await _fileService.savePdf(name: newResume.id, bytes: pdfBytes);
      return const Success(unit);
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception('Erro ao salvar currículo.'));
    }
  }
}
