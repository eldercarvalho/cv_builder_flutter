import 'package:cv_builder/data/repositories/auth_repository/auth_repository.dart';
import 'package:cv_builder/data/repositories/auth_repository/auth_repository_remote.dart';
import 'package:cv_builder/data/repositories/resume_repository/resume_repository_remote.dart';
import 'package:cv_builder/data/services/api/auth_service.dart';
import 'package:cv_builder/data/services/api/remote_service.dart';
import 'package:cv_builder/data/services/local/file_service.dart';
import 'package:cv_builder/data/services/local/local_service.dart';
import 'package:cv_builder/ui/pages/auth/auth_view_model.dart';
import 'package:cv_builder/ui/pages/home/home.dart';
import 'package:cv_builder/ui/pages/resume_form/view_model/resume_form_finished_view_model.dart';
import 'package:cv_builder/ui/pages/resume_form/view_model/resume_form_view_model.dart';
import 'package:cv_builder/ui/pages/resume_preview/resume_preview.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories/resume_repository/resume_respository.dart';
import '../ui/pages/login/view_model/login_view_model.dart';
import '../ui/pages/recover_password/recover_password_view_model.dart';
import '../ui/pages/registration/view_model/registration_view_model.dart';
import '../ui/pages/splash/view_model/splash_view_model.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton<FileService>(() => FileService());
  getIt.registerLazySingleton<LocalService>(() => LocalService());
  getIt.registerLazySingleton<RemoteService>(() => RemoteService());
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Repositories
  getIt.registerLazySingleton<ResumeRepository>(() => ResumeRepositoryRemote(
        remoteService: getIt(),
        fileService: getIt(),
      ));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryRemote(
        authService: getIt(),
      ));

  // ViewModels
  getIt.registerFactory(() => HomeViewModel(
        authRepository: getIt(),
        resumeRepository: getIt(),
      ));
  getIt.registerFactory(() => ResumeFormViewModel(
        authRepository: getIt(),
        resumeRepository: getIt(),
      ));
  getIt.registerFactory(() => ResumePreviewViewModel(
        authRepository: getIt(),
        resumeRepository: getIt(),
      ));
  getIt.registerFactory(() => ResumeFormFinishedViewModel(
        authRepository: getIt(),
        resumeRepository: getIt(),
      ));
  getIt.registerFactory(() => AuthViewModel(
        authRepository: getIt(),
      ));
  getIt.registerFactory(() => LoginViewModel(
        authRepository: getIt(),
      ));
  getIt.registerFactory(() => RegistrationViewModel(
        authRepository: getIt(),
      ));
  getIt.registerFactory(() => SplashViewModel(
        authRepository: getIt(),
      ));
  getIt.registerFactory(() => RecoverPasswordViewModel(
        authRepository: getIt(),
      ));
}

// Services
