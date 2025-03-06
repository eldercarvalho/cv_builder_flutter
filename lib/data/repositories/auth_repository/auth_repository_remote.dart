import 'package:result_dart/result_dart.dart';

import '../../../domain/dtos/authentication_data.dart';
import '../../../domain/dtos/registration_data.dart';
import '../../../domain/models/user.dart';
import '../../models/user.dart';
import '../../services/api/auth_service.dart';
import 'auth_repository.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({required AuthService authService}) {
    _authService = authService;
  }

  late final AuthService _authService;

  @override
  bool get isAuthenticated => _authService.currentUser != null;

  @override
  User? get currentUser => _authService.currentUser?.toDomain();

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges.map((user) => user?.toDomain());

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

  @override
  AsyncResult<void> resetPassword(String email) {
    return _authService.sendPasswordResetEmail(email);
  }

  @override
  AsyncResult<User> getCurrentUser() {
    return _authService.getCurrentUser().map((user) => user.toDomain());
  }

  @override
  AsyncResult<void> loginWithGoogle() {
    return _authService.signInWithGoogle();
  }

  @override
  AsyncResult<Unit> deleteAccount() {
    return _authService.deleteAccount();
  }

  @override
  AsyncResult<void> updatePassword(String password) {
    return _authService.updatePassword(password);
  }

  @override
  AsyncResult<void> updateProfile(User user) {
    return _authService.updateProfile(UserModel.fromDomain(user));
  }

  @override
  AsyncResult<List<String>> getSignInMethods() async {
    return _authService.getSignInMethods();
  }
}
