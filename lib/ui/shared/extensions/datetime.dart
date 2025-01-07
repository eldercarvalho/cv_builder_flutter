import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeExtension on DateTime {
  String toSimpleDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String timeAgo() {
    return timeago.format(this, locale: 'pt');
  }

  String toShortDate() {
    return DateFormat('MMM yyyy').format(this);
  }
}
