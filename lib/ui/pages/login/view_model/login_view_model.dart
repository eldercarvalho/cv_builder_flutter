import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';
import '../../../../domain/dtos/authentication_data.dart';
import '../../../../utils/command.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required AuthRepository authRepository}) {
    _authRepository = authRepository;
    login = Command1(_login);
    loginWithGoogle = Command0(_loginWithGoogle);
  }

  late final AuthRepository _authRepository;
  late final Command1<Unit, AuthenticationData> login;
  late final Command0<Unit> loginWithGoogle;

  AsyncResult<Unit> _login(AuthenticationData data) async {
    final result = await _authRepository.login(data);
    return result.fold(
      (_) => const Success(unit),
      (error) => Failure(error),
    );
  }

  AsyncResult<Unit> _loginWithGoogle() async {
    final result = await _authRepository.loginWithGoogle();
    return result.fold(
      (_) => const Success(unit),
      (error) => Failure(error),
    );
  }
}
