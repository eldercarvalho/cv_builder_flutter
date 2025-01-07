import 'package:cv_builder/data/services/api/remote_service.dart';
import 'package:cv_builder/data/services/local/file_service.dart';
import 'package:cv_builder/data/services/local/local_service.dart';
import 'package:cv_builder/domain/models/resume.dart';
import 'package:cv_builder/ui/shared/resume_models/simple/simple.dart';
import 'package:cv_builder/utils/command.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required RemoteService remoteService,
    required LocalService localService,
    required FileService fileService,
  }) {
    getResumes = Command0(_getResumes);
    _remoteService = remoteService;
    _localService = localService;
    _fileService = fileService;
  }

  late final Command0 getResumes;
  late final RemoteService _remoteService;
  late final LocalService _localService;
  late final FileService _fileService;

  List<Resume> _resumes = [];
  List<Resume> get resumes => _resumes;
  final _log = Logger('HomeViewModel');

  Future<void> clearCache() async {
    final id = await _localService.getGuestId();
    _localService.clear();
    _remoteService.deleteGuestUser(id!);
  }

  Future<void> saveResume() async {
    try {
      final id = await _localService.getGuestId();
      final resume = Resume.fake();
      final pdfBytes = await SimpleResumeTemplate.generatePdf(resume);
      final imageBytes = await SimpleResumeTemplate.generateThumbnail(pdfBytes);
      await _remoteService.saveResume(id!, resume);
      await _fileService.saveImage(name: 'thumbnail_${resume.id}', bytes: imageBytes);
      await _fileService.savePdf(name: resume.id, bytes: pdfBytes);
    } catch (e) {
      _log.severe('Error saving resume', e);
    }
  }

  Future<Result<String>> _getResumes() async {
    try {
      final userId = await _localService.getGuestId();
      List<Resume> tmpResumes = [];

      final resumeModels = await _remoteService.getResumes(userId!);
      final resumes = resumeModels.map((e) => e.toDomain()).toList();

      for (final resume in resumes) {
        final thumbnail = await _fileService.getImage(name: 'thumbnail_${resume.id}');
        if (thumbnail.existsSync()) {
          tmpResumes.add(resume.copyWith(thumbnail: thumbnail.path));
        }
      }

      _resumes = tmpResumes;

      notifyListeners();
      return const Success('');
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
