

import 'package:intl/intl.dart';

extension IntExt on int {
  String displayDate() {
    final DateFormat formatter = DateFormat('hh:mm a, dd MMM, yyyy');
    return formatter.format(DateTime.fromMicrosecondsSinceEpoch(this));
  }
}