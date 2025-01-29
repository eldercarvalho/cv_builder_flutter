import 'package:cv_builder/data/repositories/auth_repository/auth_repository.dart';
import 'package:cv_builder/domain/dtos/registration_data.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../utils/command.dart';

class RegistrationViewModel extends ChangeNotifier {
  RegistrationViewModel({required AuthRepository authRepository}) {
    _authRepository = authRepository;
    register = Command1(_register);
  }

  late final AuthRepository _authRepository;
  late final Command1<Unit, RegistrationData> register;

  AsyncResult<Unit> _register(RegistrationData data) async {
    final result = await _authRepository.register(data);
    return result.fold(
      (_) => const Success(unit),
      (error) => Failure(error),
    );
  }
}
