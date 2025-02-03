import 'package:flutter/foundation.dart';

import '../../../../data/repositories/auth_repository/auth_repository.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel({required AuthRepository authRepository}) : _authRepository = authRepository;

  late final AuthRepository _authRepository;

  bool get isAuthenticated => _authRepository.isAuthenticated;
}
