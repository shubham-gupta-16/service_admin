import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/api_constants.dart';

import 'auth.dart';

class NewDeviceConnector {
  final DatabaseReference _dbRef;
  final Auth auth;
  final _random = Random();

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
      "adminUid": auth.requireUid,
      "adminUsername": auth.requireUserName,
    });
    return true;
  }

  Future<int> createNewLink() async {
    final code = _random.nextInt(899999) + 100000;
    final Completer<int> completer = Completer();
    await close();
    _key = code.toString();
    await _dbRef.child(DbRef.connectionRequest).child(_key!).set({
      "admin": auth.requireUid,
      "username": auth.requireUserName,
      "createdOn": DateTime.now().millisecondsSinceEpoch
    }).then((_) {
      completer.complete(code);
    }).catchError((err) {
      completer.completeError(err.toString());
    });
    return completer.future;
  }

  Future<void> close() async {
    if (_key == null) return;
    await _dbRef.child(DbRef.connectionRequest).child(_key!).remove();
    _key = null;
  }
}
