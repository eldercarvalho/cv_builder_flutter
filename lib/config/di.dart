import 'package:cv_builder/data/repositories/auth_repository/auth_repository.dart';
import 'package:cv_builder/data/repositories/auth_repository/auth_repository_remote.dart';
import 'package:cv_builder/data/repositories/resume_repository/resume_repository_remote.dart';
import 'package:cv_builder/data/services/api/auth_service.dart';
import 'package:cv_builder/data/services/api/remote_service.dart';
import 'package:cv_builder/data/services/local/file_service.dart';
import 'package:cv_builder/data/services/local/local_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/resume_repository/resume_respository.dart';

// Services
List<SingleChildWidget> get providers => [
      Provider(
        lazy: true,
        create: (_) => FileService(),
      ),
      Provider(
        lazy: true,
        create: (_) => LocalService(),
      ),
      Provider(
        lazy: true,
        create: (_) => RemoteService(),
      ),
      Provider(
        lazy: true,
        create: (context) => ResumeRepositoryRemote(
          remoteService: context.read(),
          fileService: context.read(),
        ) as ResumeRepository,
      ),
      Provider(
        lazy: true,
        create: (_) => AuthService(),
      ),
      ChangeNotifierProvider(
        create: (context) => AuthRepositoryRemote(authService: context.read()) as AuthRepository,
      ),
    ];
