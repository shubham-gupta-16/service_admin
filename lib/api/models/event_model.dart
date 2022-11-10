
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:service_admin/api/utils.dart';

class EventDateGroup {
  final String date;
  final List<EventModel> subList;

  EventDateGroup(this.date, this.subList);
}

class EventModel {
  final int event;
  final String? text;
  final String? desc;
  final String? nTitle;
  final String? nText;
  final String? nText2;
  final String? nPackage;
  final int timestampAsKey;

  EventModel(this.event, this.text, this.desc, this.nTitle, this.nText,
      this.nText2, this.nPackage, this.timestampAsKey);

  factory EventModel.fromSnapshot(DataSnapshot snapshot) => EventModel(
      snapshot.child("event").value as int? ?? 0,
      (snapshot.child("text").value as String?),
      (snapshot.child("desc").value as String?),
      (snapshot.child("nTitle").value as String?).decode(),
      (snapshot.child("nText").value as String?).decode(),
      (snapshot.child("nText2").value as String?).decode(),
      (snapshot.child("nPackage").value as String?).decode(),
      int.tryParse(snapshot.key ?? "0") ?? 0);

  factory EventModel.loader(String key) => EventModel(-1, null, null, null,
      null, null, null, (int.tryParse(key ?? "0") ?? 1) - 1);

  @override
  String toString() {
    return {"event": event, "timeStampAsKey": timestampAsKey, "text": text}
        .toString();
  }

  static Color getEventColor(int event) {
    switch (event) {
      case 1:
        return Colors.green;
      case 8:
        return Colors.red;
      case 16:
        return Colors.blue;
      case 64:
        return Colors.amber;
      default:
        return Colors.blueGrey;
    }
  }
  static String? getEventName(int event) {
    switch (event) {
      case 1:
        return "Clicked";
      case 8:
        return "Focused";
      case 16:
        return "Typed";
      case 64:
        return "Notification";
      default: return null;
    }
  }
}
