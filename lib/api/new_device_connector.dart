import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/api_constants.dart';

import 'auth.dart';

class NewDeviceConnector {
  final DatabaseReference _dbRef;
  final Auth auth;

  NewDeviceConnector(this._dbRef, this.auth);

  String? _key;

  Future<bool> verifyCode(String code) async {
    final snapshot = await _dbRef
        .child(DbRef.connectionRequest)
        .orderByChild("code")
        .equalTo(code)
        .get();
    if (!snapshot.exists) return false;
    await _dbRef
        .child(DbRef.connectionRequest)
        .child(snapshot.children.first.key!)
        .update({
      "adminUid": auth.requireUsername,
    });
    return true;
  }

  Future<void> close() async {
    if (_key == null) return;
    await _dbRef.child(DbRef.connectionRequest).child(_key!).remove();
    _key = null;
  }
}
