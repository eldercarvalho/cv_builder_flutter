import 'package:cv_builder/config/routing/router.dart';
import 'package:cv_builder/config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CvBuilderApp extends StatefulWidget {
  const CvBuilderApp({super.key});

  @override
  State<CvBuilderApp> createState() => _CvBuilderAppState();
}

class _CvBuilderAppState extends State<CvBuilderApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Currículo Top',
      theme: CvBuilderTheme.lightTheme,
      routerConfig: router(context.read()),
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
