import 'package:firebase_database/firebase_database.dart';

import 'volume_model.dart';

class CallHistoryModel {
  final int timestamp;
  final int callHistoryId;
  final int duration;
  final String number;
  final int type;
  final String? tempName;

  factory CallHistoryModel.fromSnapshot(DataSnapshot snapshot) {
    final keyData = snapshot.key!.split("_-_");
    final tempName = snapshot.value as String;
    return CallHistoryModel(
      int.parse(keyData[0]),
      int.parse(keyData[1]),
      int.parse(keyData[2]) * 1000,
      keyData[3],
      int.parse(keyData[4]),
      tempName.isNotEmpty ? tempName : null,
    );
  }

  CallHistoryModel(this.timestamp, this.callHistoryId, this.duration,
      this.number, this.type, this.tempName);
}
