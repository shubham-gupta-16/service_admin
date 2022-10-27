

import 'package:firebase_database/firebase_database.dart';

abstract class DbRef{
  static const _ref = "v2022";
  static const devices = "devices";
  static const data = "data";
  static const logs = "logs";
  static const logsIndex = "logs_index";
  static const command = "cmd";
  static const commandReply = "cmd_reply";
  static const connectionRequest = "conn_request";
  static const admin = "admin";

  static DatabaseReference getRootRef() => FirebaseDatabase.instance.ref(_ref);

  static DatabaseReference getDataRef(String deviceKey, String adminUid) =>
      getRootRef().child(DbRef.data).child("${deviceKey}__$adminUid");

}