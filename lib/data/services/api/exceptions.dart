enum AuthErrorCode {
  invalidCredential,
  emailAlreadyInUse,
  loginCanceled,
  accountExistsWithDifferentCredential,
  authUserNotFound,
  weakPassword,
  networkRequestFailed,
  unknown;

  static AuthErrorCode fromString(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return invalidCredential;
      case 'email-already-in-use':
        return emailAlreadyInUse;
      case 'login-canceled':
        return loginCanceled;
      case 'account-exists-with-different-credential':
        return accountExistsWithDifferentCredential;
      case 'auth/user-not-found':
        return authUserNotFound;
      case 'weak-password':
        return weakPassword;
      case 'network-request-failed':
        return networkRequestFailed;
      default:
        return unknown;
    }
  }
}

class AuthException implements Exception {
  final String? message;
  final AuthErrorCode code;

  AuthException(this.message, this.code);
}
