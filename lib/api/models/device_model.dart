import 'package:firebase_database/firebase_database.dart';

class DeviceModel {
  final String deviceKey;
  final String name;
  final int status;
  final int lastSeen;

  DeviceModel(this.deviceKey, this.name, this.status, this.lastSeen);

  factory DeviceModel.fromSnapshot(DataSnapshot snapshot) {
    return DeviceModel(
        snapshot.key!,
        snapshot.child("name").value as String? ?? "No Name",
        snapshot.child("status").value as int? ?? 0,
        snapshot.child("lastOnline").value as int? ?? 0);
  }
}
