import 'package:flutter/material.dart';

import '../domain/models/resume.dart';
import '../ui/pages/pages.dart';

abstract class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings settings) {
    return {
      SplashPage.route: (BuildContext context) => const SplashPage(),
      HomePage.route: (BuildContext context) {
        return const HomePage();
      },
      ResumeFormPage.route: (BuildContext context) {
        return ResumeFormPage(
          params: settings.arguments as ResumeFormParams?,
        );
      },
      ResumePreviewPage.route: (BuildContext context) {
        return ResumePreviewPage(
          params: settings.arguments as ResumePreviewParams,
        );
      },
      ResumeFormFinishedPage.route: (BuildContext context) {
        return ResumeFormFinishedPage(
          resume: settings.arguments as Resume,
        );
      },
      LoginPage.route: (BuildContext context) {
        return const LoginPage();
      },
      RegistrationPage.route: (BuildContext context) {
        return const RegistrationPage();
      },
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final WidgetBuilder? builder = getRoutes(settings)[settings.name];

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder?.call(context) ?? const SizedBox(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
