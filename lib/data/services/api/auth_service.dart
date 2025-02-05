import 'dart:async';

import 'package:cv_builder/data/models/user.dart';
import 'package:cv_builder/domain/dtos/authentication_data.dart';
import 'package:cv_builder/domain/dtos/registration_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:result_dart/result_dart.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<UserModel?> get authStateChanges => _firebaseAuth.authStateChanges().map((user) {
        if (user != null) {
          return UserModel(
            id: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
          );
        }
        return null;
      });

  UserModel? get currentUser {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
      );
    }
    return null;
  }

  AsyncResult<User> signInWithEmailAndPassword(AuthenticationData data) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, e.code);
      return Failure(exception);
    }
  }

  AsyncResult<User> signInWithGoogle() async {
    try {
      // Inicia o processo de login com o Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // O usuário cancelou o login
        return Failure(AuthException('Login canceled', 'login-canceled'));
      }

      // Obtém os detalhes de autenticação do Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Cria uma credencial para o Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autentica o usuário no Firebase
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, e.code);
      return Failure(exception);
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
      final exception = AuthException(e.message, e.code);
      return Failure(exception);
    }
  }

  AsyncResult<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Success(unit);
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, e.code);
      return Failure(exception);
    }
  }

  AsyncResult<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(unit);
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, e.code);
      return Failure(exception);
    }
  }

  AsyncResult<UserModel> getCurrentUser() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final userModel = UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );
        return Success(userModel);
      }
      throw Exception('User not found');
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, e.code);
      return Failure(exception);
    }
  }
}

class AuthException implements Exception {
  final String? message;
  final String code;

  AuthException(this.message, this.code);
}
