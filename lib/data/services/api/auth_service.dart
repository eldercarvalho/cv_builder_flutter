import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cv_builder/data/models/user.dart';
import 'package:cv_builder/data/services/api/exceptions.dart';
import 'package:cv_builder/domain/dtos/authentication_data.dart';
import 'package:cv_builder/domain/dtos/registration_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:result_dart/result_dart.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    }
  }

  AsyncResult<User> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Inicia o processo de login com o Google
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // O usuário cancelou o login
        return Failure(AuthException('Login canceled', AuthErrorCode.loginCanceled));
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

      // Cria um documento para o usuário no Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': googleUser.displayName,
        'email': googleUser.email,
      });

      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    } catch (e) {
      return Failure(AuthException(e.toString(), AuthErrorCode.unknown));
    }
  }

  AsyncResult<User> createUserWithEmailAndPassword(RegistrationData data) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );

      await userCredential.user!.updateDisplayName(data.name);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': data.name,
        'email': data.email,
      });

      return Success(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    }
  }

  AsyncResult<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Success(unit);
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    }
  }

  AsyncResult<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Success(unit);
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
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
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    }
  }

  AsyncResult<void> updateProfile(UserModel user) async {
    try {
      final User? firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).update({
          'name': user.name,
          'email': user.email,
        });
        await firebaseUser.updateDisplayName(user.name);
        // await firebaseUser.verifyBeforeUpdateEmail(user.email);
        return const Success(unit);
      }
      throw Exception('User not found');
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    } on FirebaseException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    }
  }

  AsyncResult<void> updatePassword(String password) async {
    try {
      final User? firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.updatePassword(password);
        return const Success(unit);
      }
      throw Exception('User not found');
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    }
  }

  AsyncResult<Unit> deleteAccount() async {
    final User? firebaseUser = _firebaseAuth.currentUser;
    try {
      if (firebaseUser != null) {
        await _firestore.collection('users').doc(firebaseUser.uid).delete();
        await firebaseUser.delete();
        return const Success(unit);
      }
      throw Exception('User not found');
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    } on FirebaseException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    }
  }

  AsyncResult<List<String>> getSignInMethods() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        return const Success([]);
      }

      List<String> providers = currentUser.providerData.map((userInfo) => userInfo.providerId).toList();

      return Success(providers);
    } on FirebaseAuthException catch (e) {
      final exception = AuthException(e.message, AuthErrorCode.fromString(e.code));
      return Failure(exception);
    }
  }
}
