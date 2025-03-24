import 'dart:ui';

import 'package:cv_builder/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // debugPrintRebuildDirtyWidgets = true;

  await ScreenUtil.ensureScreenSize();

  runApp(const CvBuilderApp());
}
