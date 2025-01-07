import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AsyncResult<User> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(userCredential.user!);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
