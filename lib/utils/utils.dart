

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension IntExt on int {
  String displayDate() {
    final DateFormat formatter = DateFormat('hh:mm a, dd MMM, yyyy');
    return formatter.format(DateTime.fromMicrosecondsSinceEpoch(this));
  }
}

extension Context on BuildContext {
  void navigatePush(Widget page){
    Navigator.push(this, MaterialPageRoute(builder: (context)=>page));
  }
}