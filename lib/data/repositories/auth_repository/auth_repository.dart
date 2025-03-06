import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../domain/dtos/authentication_data.dart';
import '../../../domain/dtos/registration_data.dart';
import '../../../domain/models/user.dart';

abstract class AuthRepository extends ChangeNotifier {
  AsyncResult<void> login(AuthenticationData data);
  AsyncResult<void> loginWithGoogle();
  AsyncResult<void> register(RegistrationData data);
  AsyncResult<void> resetPassword(String email);
  AsyncResult<void> logout();
  AsyncResult<Unit> deleteAccount();
  AsyncResult<void> updateProfile(User user);
  AsyncResult<void> updatePassword(String password);
  AsyncResult<User> getCurrentUser();
  AsyncResult<List<String>> getSignInMethods();
  bool get isAuthenticated;
  User? get currentUser;
  Stream<User?> get authStateChanges;
}
