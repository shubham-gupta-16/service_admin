import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/utils/utils.dart';
import 'package:service_admin/utils/utils.dart';
import 'package:service_admin/utils/utils.dart';
import 'package:service_admin/utils/utils.dart';
import 'package:service_admin/utils/utils.dart';
import 'package:service_admin/utils/utils.dart';

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
      (snapshot.child("text").value as String?).decode(),
      (snapshot.child("desc").value as String?).decode(),
      (snapshot.child("nTitle").value as String?).decode(),
      (snapshot.child("nText").value as String?).decode(),
      (snapshot.child("nText2").value as String?).decode(),
      (snapshot.child("nPackage").value as String?).decode(),
      int.tryParse(snapshot.key ?? "0") ?? 0);
}
