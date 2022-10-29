import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/firebase/database.dart';
import 'api_constants.dart';
import 'models/device_model.dart';

class AllDevicesConnection {
  final DatabaseReference _dbRef;
  final Auth auth;

  AllDevicesConnection(this._dbRef, this.auth);

  DatabaseReference get _deviceRef => _dbRef.child(DbRef.devices);

  StreamController<List<DeviceModel>>? _onDeviceAddedController;

  Stream<List<DeviceModel>>? get stream => _onDeviceAddedController?.stream;

  void start() {
    _onDeviceAddedController = _deviceRef
        .orderByChild(DbRef.admin)
        .equalTo(auth.requireUsername)
        .stream<DeviceModel>(
            converter: (snapshot) => DeviceModel.fromSnapshot(snapshot),
            finder: (p1, p2) => p1.deviceKey == p2.deviceKey);
  }

  void close() {
    _onDeviceAddedController?.close();
    print("all devices conn close");
  }
}
