import 'dart:io';
import 'dart:typed_data';

import 'package:result_dart/result_dart.dart';

import '../../../domain/models/resume.dart';
import '../../models/resume.dart';
import '../../services/api/remote_service.dart';
import '../../services/local/file_service.dart';
import 'resume_respository.dart';

class ResumeRepositoryRemote extends ResumeRepository {
  ResumeRepositoryRemote({
    required RemoteService remoteService,
    required FileService fileService,
  })  : _remoteService = remoteService,
        _fileService = fileService;

  late final RemoteService _remoteService;
  late final FileService _fileService;

  final _resumes = <Resume>[];

  @override
  List<Resume> get resumes => _resumes;

  @override
  AsyncResult<Resume> getResume({
    required String userId,
    required String resumeId,
  }) async {
    return await _remoteService //
        .getResume(userId, resumeId)
        .map((resume) => resume.toDomain());
  }

  @override
  AsyncResult<List<Resume>> getResumes({required String userId}) async {
    return _remoteService
        .getResumes(userId)
        .map((resumes) => resumes.map((e) => e.toDomain()).toList())
        .onSuccess(_onGetResumeSuccess);
  }

  void _onGetResumeSuccess(List<Resume> resumes) {
    _resumes.clear();
    _resumes.addAll(resumes);
    notifyListeners();
  }

  @override
  AsyncResult<Unit> saveResume({
    required String userId,
    required Resume resume,
  }) async {
    final thumbnailBytes = await resume.toThumbnail();
    return await _fileService
        .saveTempImage(name: resume.id, bytes: thumbnailBytes)
        .flatMap((thumbFile) => _remoteService.saveResume(userId, ResumeModel.fromDomain(resume), thumbFile))
        .map((resumeModel) => resumeModel.toDomain())
        .onSuccess(_onSaveResumeSuccess)
        .pure(unit);
  }

  void _onSaveResumeSuccess(Resume resume) {
    final index = _resumes.indexWhere((e) => e.id == resume.id);

    if (index != -1) {
      _resumes[index] = resume;
      notifyListeners();
      return;
    }

    _resumes.insert(0, resume);
    notifyListeners();
  }

  @override
  AsyncResult<File> getPdf({required Resume resume}) async {
    final pdfBytes = await resume.toPdf();
    return _fileService.savePdf(name: resume.id, bytes: pdfBytes);
  }

  @override
  AsyncResult<Unit> deleteResume({required String userId, required Resume resume}) {
    return _remoteService
        .deleteResume(userId, ResumeModel.fromDomain(resume))
        .onSuccess((_) => _onDeleteResumeSuccess(resume))
        .pure(unit);
  }

  void _onDeleteResumeSuccess(Resume resume) {
    _resumes.remove(resume);
    notifyListeners();
  }

  @override
  AsyncResult<File> savePdf({required String resumeId, required Uint8List bytes}) async {
    return _fileService.savePdf(name: resumeId, bytes: bytes);
  }

  @override
  AsyncResult<Unit> deleteResumes({required String userId}) {
    return _remoteService
        .deleteResumes(userId)
        .onSuccess((_) => _resumes.clear())
        .onSuccess((_) => notifyListeners())
        .pure(unit);
  }
}
