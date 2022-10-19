

import 'package:firebase_database/firebase_database.dart';

abstract class DbRef{
  static const _ref = "v2022";
  static const devices = "devices";
  static const data = "data";
  static const log = "actions_v2";
  static const terminal = "terminal";
  static const command = "cmd";
  static const commandReply = "reply";
  static const admin = "admin";

  static DatabaseReference getFirebaseRef() => FirebaseDatabase.instance.ref(_ref);

}