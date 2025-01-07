import 'package:cv_builder/data/repositories/resume_repository/resume_repository_local.dart';
import 'package:cv_builder/data/services/api/remote_service.dart';
import 'package:cv_builder/data/services/local/file_service.dart';
import 'package:cv_builder/data/services/local/local_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

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
        create: (context) => ResumeRepositoryLocal(
          sharedPrefService: context.read(),
        ),
      ),
    ];
