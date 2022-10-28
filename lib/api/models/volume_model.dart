import 'package:firebase_database/firebase_database.dart';

class VolumeModel {
  final int music;
  final int call;
  final int alarm;
  final int ring;
  final int notification;
  final int system;

  VolumeModel(this.music, this.call, this.alarm, this.ring, this.notification,
      this.system);

  factory VolumeModel.fromSnapshot(DataSnapshot snapshot) {
    return VolumeModel(
      snapshot.child("music").value as int? ?? 0,
      snapshot.child("call").value as int? ?? 0,
      snapshot.child("alarm").value as int? ?? 0,
      snapshot.child("ring").value as int? ?? 0,
      snapshot.child("notification").value as int? ?? 0,
      snapshot.child("system").value as int? ?? 0,
    );
  }
}
