import 'package:flutter/material.dart';

import '../../../config/di.dart';
import '../../shared/extensions/context.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';
import 'view_model/splash_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const route = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _viewModel = getIt<SplashViewModel>();

  @override
  void initState() {
    super.initState();
    Future.microtask(_checkUserIsAuthenticated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          width: context.screenWidth * 0.7,
        ),
      ),
    );
  }

  Future<void> _checkUserIsAuthenticated() async {
    Future.delayed(const Duration(seconds: 2), () {
      if (_viewModel.isAuthenticated) {
        HomePage.replace(context);
      } else {
        LoginPage.replace(context);
      }
    });
  }
}
