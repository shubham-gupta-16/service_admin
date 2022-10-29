import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/models/device_model.dart';

import 'api_constants.dart';
import 'auth.dart';
import 'models/call_history_model.dart';

class DeviceDataConnection {
  final DatabaseReference _dbRef;
  final Auth auth;

  DeviceDataConnection(this._dbRef, this.auth);

  DeviceModel? deviceModel;

  DeviceModel get requireDeviceModel => deviceModel!;

  DatabaseReference get dataRef =>
      DbRef.getDataRef(requireDeviceModel.deviceKey, auth.requireUid);

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
    try {
      final snapshot = await dataRef.child(DbRef.callHistory).get();

      print('.................');
      print(snapshot.value);
      if (!snapshot.exists) return Future.error("Not Found");
      final List<CallHistoryModel> list = [];
      for (final s in snapshot.children) {
        list.insert(0, CallHistoryModel.fromSnapshot(s));
      }
      print(list);
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
