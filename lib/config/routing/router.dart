import 'package:cv_builder/ui/pages/login/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository/auth_repository.dart';
import '../../domain/models/resume.dart';
import '../../ui/pages/home/home.dart';
import '../../ui/pages/login/login_page.dart';
import '../../ui/pages/registration/registration_page.dart';
import '../../ui/pages/registration/view_model/registration_view_model.dart';
import '../../ui/pages/resume_form/resume_form.dart';
import '../../ui/pages/resume_form/resume_form_finished_page.dart';
import '../../ui/pages/resume_form/view_model/resume_form_finished_view_model.dart';
import '../../ui/pages/resume_preview/resume_preview.dart';
import '../../ui/pages/splash/splash.dart';
import 'routes.dart';
import 'transition_page.dart';

GoRouter router(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: Routes.home,
    redirect: _redirect,
    refreshListenable: authRepository,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => SplashPage(
          viewModel: SplashViewModel(
            localService: context.read(),
            remoteService: context.read(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          final viewModel = HomeViewModel(
            authRepository: context.read(),
            remoteService: context.read(),
            localService: context.read(),
            fileService: context.read(),
          );

          viewModel.getResumes.execute();

          return HomePage(viewModel: viewModel);
        },
      ),
      GoRoute(
        path: ResumeFormPage.path,
        pageBuilder: (context, state) {
          final parms = state.extra as ResumeFormParams?;
          final viewModel = ResumeFormViewModel(
            localService: context.read(),
            remoteService: context.read(),
            fileService: context.read(),
          );

          return slideTransitionPage(
            state: state,
            child: ResumeFormPage(viewModel: viewModel, params: parms),
          );
        },
      ),
      GoRoute(
        path: ResumePreviewPage.path,
        pageBuilder: (context, state) {
          final resumeId = state.pathParameters['resumeId']!;
          final params = state.extra as ResumePreviewParams;

          final viewModel = ResumePreviewViewModel(
            localService: context.read(),
            remoteService: context.read(),
            fileService: context.read(),
          );

          viewModel.getResume.execute(resumeId);

          return slideTransitionPage(
            state: state,
            child: ResumePreviewPage(
              viewModel: viewModel,
              params: params,
            ),
          );
        },
      ),
      GoRoute(
        path: ResumeFormFinishedPage.path,
        pageBuilder: (context, state) {
          final resume = state.extra as Resume;
          final viewModel = ResumeFormFinishedViewModel(
            localService: context.read(),
            remoteService: context.read(),
            fileService: context.read(),
          );

          return slideTransitionPage(
            state: state,
            child: ResumeFormFinishedPage(
              resume: resume,
              viewModel: viewModel,
            ),
          );
        },
      ),
      GoRoute(
        path: RegistrationPage.path,
        pageBuilder: (context, state) {
          final viewModel = RegistrationViewModel(
            authRepository: context.read(),
          );

          return slideTransitionPage(
            state: state,
            child: RegistrationPage(viewModel: viewModel),
          );
        },
      ),
      GoRoute(
        path: LoginPage.path,
        pageBuilder: (context, state) {
          final viewModel = LoginViewModel(
            authRepository: context.read(),
          );

          return slideTransitionPage(
            state: state,
            child: LoginPage(viewModel: viewModel),
          );
        },
      ),
    ],
  );
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == LoginPage.path;

  if (!loggedIn) {
    return LoginPage.path;
  }

  if (loggingIn) {
    return HomePage.path;
  }

  return null;
}
