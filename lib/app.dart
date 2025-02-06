import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/routes.dart';
import 'config/theme/theme.dart';

class CvBuilderApp extends StatefulWidget {
  const CvBuilderApp({super.key});

  @override
  State<CvBuilderApp> createState() => _CvBuilderAppState();
}

class _CvBuilderAppState extends State<CvBuilderApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Currículo Top',
          theme: CvBuilderTheme.lightTheme,
          // locale: const Locale('pt'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // home: AuthPage(),
          onGenerateRoute: Routes.onGenerateRoute,
        );
      },
    );
  }
}
