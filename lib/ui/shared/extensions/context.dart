import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextEx on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  // Function(String) get showErrorSnackbar => (String text) => showSnackBar(
  //       context: this,
  //       text: text,
  //       type: SnackBarType.error,
  //     );
}
