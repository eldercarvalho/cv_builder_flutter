import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';
import 'auth_view_model.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final _viewModel = getIt<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Navigator(
          key: GlobalKey<NavigatorState>(),
          onGenerateRoute: (settings) {
            if (!_viewModel.isUserAuthenticated) {
              return MaterialPageRoute(builder: (_) => const LoginPage());
            } else {
              return MaterialPageRoute(builder: (_) => const HomePage());
            }
          },
        );
      },
    );
  }
}
