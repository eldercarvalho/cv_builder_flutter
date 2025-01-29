import 'dart:async';

import 'package:cv_builder/data/models/user.dart';
import 'package:cv_builder/domain/dtos/authentication_data.dart';
import 'package:cv_builder/domain/dtos/registration_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthService() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        _authStateController.add(UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        ));
      } else {
        _authStateController.add(null);
      }
    });
  }

  final _authStateController = StreamController<UserModel?>();

  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  UserModel? get currentUser {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
    }
    throw Exception('User not found');
  }

  AsyncResult<User> signInWithEmailAndPassword(AuthenticationData data) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<User> createUserWithEmailAndPassword(RegistrationData data) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );

      await userCredential.user!.updateDisplayName(data.name);

      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(unit);
    } on FirebaseAuthException catch (e) {
      return Failure(e);
    }
  }
}
