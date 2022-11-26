import 'package:firebase_database/firebase_database.dart';

class EventsDateModel {
  final String date;
  final int count;

  EventsDateModel(this.date, this.count);

  factory EventsDateModel.fromSnapshot(DataSnapshot snapshot) =>
      EventsDateModel(snapshot.key!, snapshot.child("text").value as int? ?? 0);

  @override
  String toString() {
    return {
      "date": date,
      "count": count,
    }.toString();
  }
}
