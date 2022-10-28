import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const List<int> _times = [
  365 * 30 * 24 * 60 * 60 * 1000,
  30 * 24 * 60 * 60 * 1000,
  24 * 60 * 60 * 1000, // 1 day
  60 * 60 * 1000, //1 hour
  60 * 1000, //1 min
  1000 //1 sed
];
const _timesString = ["year", "month", "day", "hour", "minute", "second"];

final _prettyDate = DateFormat("dd-MM-yyyy");

extension Timestamp on int {
  String displayDate() {
    final DateFormat formatter = DateFormat('hh:mm a, dd MMM, yyyy');
    return formatter.format(DateTime.fromMicrosecondsSinceEpoch(this * 1000));
  }

  String formatDate() {
    return _prettyDate.format(DateTime.fromMillisecondsSinceEpoch(this));
  }

  String formatDuration() {
    String res = "";
    for (int i = 0; i < _times.length; i++) {
      final current = _times[i];
      final temp = this ~/ current;
      if (temp > 0) {
        res = "$temp ${_timesString[i]}${temp != 1 ? 's' : ''}";
        break;
      }
    }
    return res.isEmpty ? "0 seconds" : res;
  }
}

extension StringExt on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String nonCapitalize() {
    return "${this[0].toLowerCase()}${substring(1)}";
  }
}

extension Context on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  void navigatePush(Widget page) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => page));
  }

  void navigatePushReplace(Widget page) {
    Navigator.pushReplacement(
        this, MaterialPageRoute(builder: (context) => page));
  }

  void navigatePop() {
    Navigator.pop(this);
  }

  showLoaderDialog() {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: const [
          CircularProgressIndicator(),
          SizedBox(
            width: 7,
          ),
          Text("Loading..."),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: this,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
