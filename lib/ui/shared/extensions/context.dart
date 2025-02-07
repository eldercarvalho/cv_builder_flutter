import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef PushFunction = Future<T?> Function<T extends Object?>(String, {Object? arguments});
typedef ReplaceFunction = Future<T?> Function<T extends Object?, TO extends Object?>(String,
    {Object? arguments, TO? result});

extension ContextEx on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  PushFunction get pushNamed => Navigator.of(this).pushNamed;
  ReplaceFunction get replaceNamed => Navigator.of(this).pushReplacementNamed;
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  showSuccessSnackBar(String message) => ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(FeatherIcons.checkCircle, color: Colors.white),
            const SizedBox(width: 16),
            Text(message, style: textTheme.bodyLarge?.copyWith(color: Colors.white))
          ]),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  showErrorSnackBar(String message) => ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(FeatherIcons.checkCircle, color: Colors.white),
            const SizedBox(width: 16),
            Text(message, style: textTheme.bodyLarge?.copyWith(color: Colors.white))
          ]),
          backgroundColor: Theme.of(this).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
}
