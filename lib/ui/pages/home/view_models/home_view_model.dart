import 'package:cv_builder/data/repositories/auth_repository/auth_repository.dart';
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
    required AuthRepository authRepository,
    required RemoteService remoteService,
    required LocalService localService,
    required FileService fileService,
  }) {
    _authRepository = authRepository;
    _remoteService = remoteService;
    _localService = localService;
    _fileService = fileService;
    getResumes = Command0(_getResumes);
    deleteResume = Command1(_deleteResume);
  }

  late final AuthRepository _authRepository;
  late final RemoteService _remoteService;
  late final LocalService _localService;
  late final FileService _fileService;

  late final Command0 getResumes;
  late final Command1<Unit, Resume> deleteResume;

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
      Resume resume = Resume.fake();
      final pdfBytes = await SimpleResumeTemplate.generatePdf(resume);
      final imageBytes = await SimpleResumeTemplate.generateThumbnail(pdfBytes);

      final thumbnailFile = await _fileService.saveTempImage(name: resume.id, bytes: imageBytes);
      final thumbnailUrl = await _remoteService.saveThumbnail(id!, resume.id, thumbnailFile);
      resume = resume.copyWith(thumbnail: thumbnailUrl);

      await _remoteService.saveResume(id, resume);
      await _fileService.savePdf(name: resume.id, bytes: pdfBytes);
    } catch (e) {
      _log.severe('Error saving resume', e);
    }
  }

  Future<Result<String>> _getResumes() async {
    try {
      final userId = _authRepository.currentUser?.id;
      final resumeModels = await _remoteService.getResumes(userId!);
      final resumes = resumeModels.map((e) => e.toDomain()).toList();

      _resumes = resumes;
      notifyListeners();
      return const Success('');
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<Unit> _deleteResume(Resume resume) async {
    try {
      final userId = await _localService.getGuestId();
      await _remoteService.deleteResume(userId!, resume);
      _resumes.removeWhere((element) => element.id == resume.id);
      notifyListeners();
      return const Success(unit);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<Unit> logout() async {
    final result = await _authRepository.logout();
    return result.fold(
      (_) => const Success(unit),
      (error) => Failure(error),
    );
  }
}
