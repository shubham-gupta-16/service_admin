import 'package:firebase_database/firebase_database.dart';

import 'volume_model.dart';

class DeviceModel {
  final String deviceKey;
  final String name;
  final int status;
  final int createdOn;
  final String sim1;
  final String sim2;
  final VolumeModel volume;

  DeviceModel(this.deviceKey, this.name, this.status, this.createdOn, this.sim1,
      this.sim2, this.volume);

  factory DeviceModel.fromSnapshot(DataSnapshot snapshot) {
    return DeviceModel(
      snapshot.key!.split("__")[0],
      snapshot.child("name").value as String? ?? "No Name",
      snapshot.child("status").value as int? ?? 0,
      snapshot.child("createdOn").value as int? ?? 0,
      snapshot.child("sim1").value?.toString() ?? "Unknown",
      snapshot.child("sim2").value?.toString() ?? "Unknown",
      VolumeModel.fromSnapshot(snapshot.child("volume")),
    );
  }
}
