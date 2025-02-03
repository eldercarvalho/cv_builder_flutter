import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({required AuthRepository authRepository}) : _authRepository = authRepository;

  late final AuthRepository _authRepository;

  bool get isUserAuthenticated => _authRepository.isAuthenticated;
}
