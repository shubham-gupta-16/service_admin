import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/models/device_model.dart';

import 'api_constants.dart';
import 'auth.dart';

class DeviceDataConnection {
  final DatabaseReference _dbRef;
  final Auth auth;

  DeviceDataConnection(this._dbRef, this.auth);

  DeviceModel? _deviceModel;

  DeviceModel get deviceModel => _deviceModel!;

  DatabaseReference get dataRef => DbRef.getDataRef(deviceModel.deviceKey, auth.requireUid);

  StreamSubscription? commandReplySubscription;

  void setDevice(DeviceModel deviceModel) {
    _deviceModel = deviceModel;
    commandReplySubscription = _dbRef
        .child(DbRef.commandReply)
        .onChildAdded
        .listen((event) {

    });
  }

  void runCommand(String command) {
    dataRef.child(DbRef.command).push().set(command);
  }

  void close() {
    commandReplySubscription?.cancel();
    _deviceModel = null;
  }
}
