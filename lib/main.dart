import 'package:cv_builder/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app.dart';
import 'config/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  timeago.setLocaleMessages('pt', timeago.PtBrMessages());
  setupDependencies();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // runApp(MultiProvider(
  //   providers: providers,
  //   child: const CvBuilderApp(),
  // ));
  runApp(const CvBuilderApp());
}
