import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/services/api/remote_service.dart';
import '../../../../data/services/local/file_service.dart';
import '../../../../data/services/local/local_service.dart';
import '../../../../domain/models/resume.dart';
import '../../../../utils/command.dart';

class ResumeFormFinishedViewModel extends ChangeNotifier {
  ResumeFormFinishedViewModel({
    required RemoteService remoteService,
    required LocalService localService,
    required FileService fileService,
  }) {
    // _resumeRepository = resumeRepository;
    _fileService = fileService;
    downloadResume = Command1(_downloadResume);
  }

  late final FileService _fileService;
  late final Command1<Unit, Resume> downloadResume;

  AsyncResult<Unit> _downloadResume(Resume resume) async {
    final bytes = await resume.toPdf();
    await _fileService.savePdf(name: resume.id, bytes: bytes);
    return const Success(unit);
  }
}
