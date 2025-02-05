import 'dart:io';
import 'dart:typed_data';

import 'package:result_dart/result_dart.dart';

import '../../../domain/models/resume.dart';
import '../../../ui/shared/resume_models/basic/basic.dart';
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
  AsyncResult<Unit> saveResume({
    required String userId,
    required Resume resume,
  }) async {
    final thumbnailBytes = await BasicResumeTemplate.generateThumbnail(resume);
    return await _fileService
        .saveTempImage(name: resume.id, bytes: thumbnailBytes)
        .flatMap((thumbFile) => _remoteService.saveResume(userId, ResumeModel.fromDomain(resume), thumbFile))
        .pure(unit);
  }

  @override
  AsyncResult<File> getPdf({required Resume resume}) async {
    final pdfBytes = await BasicResumeTemplate.generatePdf(resume);
    return _fileService.savePdf(name: resume.id, bytes: pdfBytes);
  }

  @override
  AsyncResult<Unit> deleteResume({required String userId, required Resume resume}) {
    return _remoteService.deleteResume(userId, ResumeModel.fromDomain(resume));
  }

  @override
  AsyncResult<List<Resume>> getResumes({required String userId}) async {
    return _remoteService
        .getResumes(userId) //
        .map((resumes) => resumes.map((e) => e.toDomain()).toList());
  }

  @override
  AsyncResult<File> savePdf({required String resumeId, required Uint8List bytes}) async {
    return _fileService.savePdf(name: resumeId, bytes: bytes);
  }
}
