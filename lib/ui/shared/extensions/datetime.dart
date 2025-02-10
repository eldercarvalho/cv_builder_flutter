import 'package:cv_builder/ui/shared/extensions/string.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeExtension on DateTime {
  String toSimpleDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String timeAgo() {
    return timeago.format(this, locale: 'pt');
  }

  String toShortDate({String locale = 'pt'}) {
    return DateFormat('MMM yyyy', locale).format(this).capitalize();
  }
}
