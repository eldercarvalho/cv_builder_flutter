import 'package:cv_builder/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'config/di.dart';
import 'data/services/messaging/messaging_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MessagingService().init();
  await ScreenUtil.ensureScreenSize();

  runApp(const CvBuilderApp());
}
