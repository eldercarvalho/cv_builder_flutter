import 'dart:io';

import 'package:cv_builder/data/services/local/file_service.dart';
import 'package:cv_builder/ui/shared/resume_models/simple/simple.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../../data/services/api/remote_service.dart';
import '../../../../data/services/local/local_service.dart';
import '../../../../domain/models/resume.dart';
import '../../../../utils/command.dart';

class ResumePreviewViewModel extends ChangeNotifier {
  ResumePreviewViewModel({
    required AuthRepository authRepository,
    required RemoteService remoteService,
    required FileService fileService,
  })  : _authRepository = authRepository,
        _remoteService = remoteService,
        _fileService = fileService;

  late final AuthRepository _authRepository;
  late final RemoteService _remoteService;
  late final FileService _fileService;
  late final Command1<Unit, String> getResume = Command1(_getResume);

  Resume? _resume;
  Resume? get resume => _resume;
  set resume(Resume? value) {
    _resume = value;
    notifyListeners();
  }

  File? _resumePdf;
  File? get resumePdf => _resumePdf;

  Future<Result<Unit>> _getResume(String resumeId) async {
    try {
      final userId = _authRepository.currentUser?.id;
      final resumeFile = await _fileService.getPdf(name: resumeId);
      final resumeModel = await _remoteService.getResume(userId!, resumeId);
      _resume = resumeModel.toDomain();
      _resumePdf = resumeFile;
      notifyListeners();
      return const Success(unit);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String>> savePdfLocally() async {
    try {
      final pdfBytes = await SimpleResumeTemplate.generatePdf(_resume!);
      final thumbnailBytes = await SimpleResumeTemplate.generateThumbnail(pdfBytes);
      final pdfFile = await _fileService.savePdf(name: _resume!.id, bytes: pdfBytes);
      await _fileService.saveImage(name: 'thumbnail_${_resume!.id}', bytes: thumbnailBytes);
      _resumePdf = pdfFile;
      notifyListeners();
      return const Success('OK');
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
