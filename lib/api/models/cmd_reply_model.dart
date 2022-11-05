import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/command.dart';
import 'package:service_admin/api/utils.dart';

import 'volume_model.dart';

class CmdReplyModel {
  final String key;
  final String deviceKey;
  final Command code;
  final int status;
  final Map<String, dynamic>? data;
  final dynamic response;

  factory CmdReplyModel.fromSnapshot(DataSnapshot snapshot) {
    return CmdReplyModel(
      snapshot.key!,
      snapshot.child("deviceKey").value as String? ?? "No Name",
      Command.fromCode(snapshot.child("code").value as int? ?? 0),
      snapshot.child("status").value as int? ?? 0,
        Map<String, dynamic>.from(snapshot.child("data").value as dynamic),
      snapshot.child("response").value
    );
  }

  CmdReplyModel(this.key, this.deviceKey, this.code, this.status, this.data, this.response);


  @override
  String toString() {
    return {
      "key": key,
      "deviceKey": deviceKey,
      "code": code,
      "status": status,
      "data": data,
      "response": response,
    }.toString();
  }
}
