import 'package:cv_builder/app.dart';
import 'package:cv_builder/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.ALL;
  timeago.setLocaleMessages('pt', timeago.PtBrMessages());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const CvBuilderApp());
}
