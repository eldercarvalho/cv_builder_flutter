import 'dart:async';

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
    _authSubscription = authRepository.authStateChanges.listen((user) {
      _isUserAuthenticated = user != null;
      notifyListeners();
    });
  }

  late final AuthRepository _authRepository;
  late final ResumeRepository _resumeRepository;
  late final StreamSubscription _authSubscription;

  late final Command0 getResumes;
  late final Command1<Unit, Resume> deleteResume;

  List<Resume> _resumes = [];
  List<Resume> get resumes => _resumes;

  bool _isUserAuthenticated = false;
  bool get isUserAuthenticated => _isUserAuthenticated;

  Future<void> saveResume() async {
    await _authRepository.getCurrentUser().flatMap((user) async {
      final resume = Resume.fake().copyWith(resumeLanguage: ResumeLanguage.en);
      await _resumeRepository.saveResume(userId: user.id, resume: resume);
      return const Success(unit);
    });
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
    return _authRepository
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.deleteResume(userId: user.id, resume: resume))
        .fold(
          (_) => _onDeleteSuccess(resume),
          (error) => Failure(error),
        );
  }

  Result<Unit> _onDeleteSuccess(Resume resume) {
    _resumes.remove(resume);
    notifyListeners();
    return const Success(unit);
  }

  AsyncResult<Unit> logout() async {
    final result = await _authRepository.logout();
    return result.fold(
      (_) => const Success(unit),
      (error) => Failure(error),
    );
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
