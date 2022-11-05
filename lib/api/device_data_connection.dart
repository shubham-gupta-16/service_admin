import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/loacal_db.dart';
import 'package:service_admin/api/models/contact_model.dart';
import 'package:service_admin/api/models/device_model.dart';

import 'api_constants.dart';
import 'auth.dart';
import 'models/call_history_model.dart';

class DeviceDataConnection {
  final DatabaseReference _dbRef;
  final Auth auth;
  final db = LocalDb();

  DeviceDataConnection(this._dbRef, this.auth);

  DeviceModel? deviceModel;

  DeviceModel get requireDeviceModel => deviceModel!;
  String get deviceKey => requireDeviceModel.deviceKey;

  DatabaseReference get dataRef =>
      DbRef.getDataRef(deviceKey, auth.requireUsername);

  StreamSubscription? commandReplySubscription;

  void setDevice(DeviceModel deviceModel) {
    this.deviceModel = deviceModel;
    commandReplySubscription =
        _dbRef
            .child(DbRef.commandReply)
            .onChildAdded
            .listen((event) {});
  }

  void runCommand(String command) {
    dataRef.child(DbRef.command).push().set(command);
  }

  Future<List<CallHistoryModel>> getCallHistory() async {
    print("called");
    final localCallHistory = db.getCallHistory(deviceKey);
    if (localCallHistory != null) {
      await Future.delayed(const Duration(milliseconds: 300));
      return localCallHistory;
    }
    try {
      final snapshot = await dataRef.child(DbRef.callHistory).get();
      print('.................');
      if (!snapshot.exists) return Future.error("Not Found");
      final List<CallHistoryModel> list = [];
      for (final s in snapshot.children) {
        list.insert(0, CallHistoryModel.fromSnapshot(s));
      }
      db.updateCallHistory(deviceKey, list);
      return list;
    } catch (e) {
      return Future.error("Not Found");
    }
  }
  Future<List<ContactModel>> getContacts() async {
    final localContacts = db.getContacts(deviceKey);
    if (localContacts != null) {
      await Future.delayed(const Duration(milliseconds: 100));
      return localContacts;
    }
    try {
      final snapshot = await dataRef.child(DbRef.contacts).get();
      if (!snapshot.exists) return Future.error("Not Found");
      final list = snapshot.children.map((e) => ContactModel.fromSnapshot(e)).toList(growable: false);
      db.updateContact(deviceKey, list);
      return list;
    } catch (e) {
      return Future.error("Not Found");
    }
  }

  void close() {
    commandReplySubscription?.cancel();
    deviceModel = null;
  }
}
