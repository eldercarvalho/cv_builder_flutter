import 'package:cv_builder/ui/shared/extensions/string.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toSimpleDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toShortDate({String locale = 'pt'}) {
    return DateFormat('MMM yyyy', locale).format(this).capitalize();
  }
}
