import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../ui/pages/home/home.dart';
import '../../ui/pages/resume_form/resume_form.dart';
import '../../ui/pages/resume_preview/resume_preview.dart';
import '../../ui/pages/splash/splash.dart';
import 'routes.dart';
import 'transition_page.dart';

final router = GoRouter(
  initialLocation: Routes.splash,
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
          remoteService: context.read(),
          localService: context.read(),
          fileService: context.read(),
        );

        viewModel.getResumes.execute();

        return HomePage(viewModel: viewModel);
      },
      routes: [
        GoRoute(
          path: Routes.resumeForm,
          pageBuilder: (context, state) {
            return slideTransitionPage(
              state: state,
              child: const ResumeFormPage(),
            );
          },
        ),
        GoRoute(
          path: ResumePreviewPage.path,
          pageBuilder: (context, state) {
            final resumeId = state.pathParameters['resumeId']!;

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
              ),
            );
          },
        ),
      ],
    ),
  ],
);
