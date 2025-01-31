import 'dart:io';
import 'dart:typed_data';

import 'package:result_dart/result_dart.dart';

import '../../../domain/models/resume.dart';
import '../../../ui/shared/resume_models/simple/simple.dart';
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
    return await _saveUserPicture(userId, resume).flatMap((resume) async {
      final pdfBytes = await SimpleResumeTemplate.generatePdf(resume);
      final thumbnailBytes = await SimpleResumeTemplate.generateThumbnail(pdfBytes);

      return await _fileService
          .saveTempImage(name: resume.id, bytes: thumbnailBytes)
          .flatMap((thumbFile) => _remoteService.saveThumbnail(userId, resume.id, thumbFile))
          .map((thumbUrl) => resume.copyWith(thumbnail: thumbUrl))
          .flatMap((resume) => _remoteService.saveResume(userId, ResumeModel.fromDomain(resume)))
          // .flatMap((resume) => _fileService.savePdf(name: resume.id, bytes: pdfBytes))
          .pure(unit);
    });
  }

  AsyncResult<Resume> _saveUserPicture(String userId, Resume resume) async {
    if (resume.photo != null && !resume.photo!.startsWith('https')) {
      return _remoteService
          .savePicture(userId, resume.id, File(resume.photo!))
          .map((url) => resume.copyWith(photo: url));
    }

    return Success(resume);
  }

  @override
  AsyncResult<File> getPdf({required String resumeId}) {
    return _fileService.getPdf(name: resumeId);
  }

  @override
  AsyncResult<Unit> deleteResume({required String userId, required Resume resume}) {
    return _remoteService.deleteResume(userId, resume);
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
