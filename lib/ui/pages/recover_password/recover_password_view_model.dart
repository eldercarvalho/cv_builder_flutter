import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../utils/command.dart';

class RecoverPasswordViewModel extends ChangeNotifier {
  RecoverPasswordViewModel({required AuthRepository authRepository}) {
    _authRepository = authRepository;
    resetPassword = Command1(_resetPassword);
  }

  late final AuthRepository _authRepository;
  late final Command1<Unit, String> resetPassword;

  AsyncResult<Unit> _resetPassword(String email) async {
    final result = await _authRepository.resetPassword(email);
    return result.fold((_) => const Success(unit), (error) => Failure(error));
  }
}
