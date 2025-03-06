import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../../data/repositories/resume_repository/resume_respository.dart';
import '../../../../domain/models/user.dart';
import '../../../../utils/command.dart';
import 'data.dart';

class AccountViewModel extends ChangeNotifier {
  AccountViewModel({required AuthRepository authRepository, required ResumeRepository resumeRepository}) {
    _authRepository = authRepository;
    _resumeRepository = resumeRepository;
    deleteAccount = Command0(_deleteAccount);
    updateAccount = Command1(_updateAccount);
  }

  late final AuthRepository _authRepository;
  late final ResumeRepository _resumeRepository;
  late final Command0 deleteAccount;
  late final Command1<Unit, UpdateAccountData> updateAccount;

  User? get user => _authRepository.currentUser;

  List<String> _signInMethods = [];
  List<String> get signInMethods => _signInMethods;

  AsyncResult<Unit> _updateAccount(UpdateAccountData data) async {
    final result = await _authRepository
        .getCurrentUser()
        .map((user) => _authRepository.updateProfile(user.copyWith(name: data.name, email: data.email)))
        .map((_) => data.password.isNotEmpty ? _authRepository.updatePassword(data.password) : const Success(unit));

    return result.fold((_) => const Success(unit), (error) => Failure(error));
  }

  AsyncResult<Unit> _deleteAccount() async {
    final result = await _authRepository
        .getCurrentUser()
        .flatMap((user) => _resumeRepository.deleteResumes(userId: user.id))
        .map((_) => _authRepository.deleteAccount())
        .map((_) => _authRepository.logout());

    return result.fold((_) => const Success(unit), (error) => Failure(error));
  }

  AsyncResult<List<String>> getSignInMethods() async {
    final result = await _authRepository.getSignInMethods();

    return result.fold(
      (methods) {
        _signInMethods = methods;
        notifyListeners();
        return Success(methods);
      },
      (error) => Failure(error),
    );
  }
}
