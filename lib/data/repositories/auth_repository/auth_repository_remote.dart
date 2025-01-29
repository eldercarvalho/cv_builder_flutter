import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../domain/dtos/authentication_data.dart';
import '../../../domain/dtos/registration_data.dart';
import '../../../domain/models/user.dart';
import '../../models/user.dart';
import '../../services/api/auth_service.dart';
import 'auth_repository.dart';

class AuthRepositoryRemote extends ChangeNotifier implements AuthRepository {
  AuthRepositoryRemote({required AuthService authService}) {
    _authService = authService;
    _authService.authStateChanges.listen((UserModel? user) {
      if (user != null) {
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
      notifyListeners();
    });
  }

  late final AuthService _authService;
  bool _isAuthenticated = false;

  @override
  Future<bool> get isAuthenticated async => _isAuthenticated;

  @override
  User? get currentUser => _authService.currentUser?.toDomain();

  @override
  AsyncResult<void> login(AuthenticationData data) {
    return _authService.signInWithEmailAndPassword(data);
  }

  @override
  AsyncResult<void> logout() {
    return _authService.logout();
  }

  @override
  AsyncResult<void> register(RegistrationData data) {
    return _authService.createUserWithEmailAndPassword(data);
  }
}
