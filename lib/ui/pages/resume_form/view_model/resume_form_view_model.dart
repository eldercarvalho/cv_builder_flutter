import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/repositories/resume_repository/resume_respository.dart';
import '../../../../domain/models/resume.dart';

class ResumeFormViewModel extends ChangeNotifier {
  ResumeFormViewModel({required ResumeRepository resumeRepository}) {
    _resumeRepository = resumeRepository;
  }

  late final ResumeRepository _resumeRepository;

  Resume? _resume;
  Resume? get resume => _resume;

  Future<void> savePersonalInfo({required String? name, required String? title}) async {
    final id = const Uuid().v4();
    final newResume = Resume.empty().copyWith(id: id, name: name, title: title);
    await _resumeRepository.saveResume(newResume);
    _resume = newResume;
    notifyListeners();
  }
}
