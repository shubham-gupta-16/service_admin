

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/auth.dart';
import 'api_constants.dart';
import 'models/device_model.dart';

class AllDevicesConnection {

  final DatabaseReference _dbRef;
  final Auth auth;
  AllDevicesConnection(this._dbRef, this.auth);

  DatabaseReference get _deviceRef => _dbRef.child(DbRef.devices);

  StreamController<List<DeviceModel>>? _onDeviceAddedController;
  final List<DeviceModel> _deviceList = [];


  Stream<List<DeviceModel>> stream() async* {
    _deviceList.clear();
    _onDeviceAddedController = StreamController();
    final addedSubscription = _deviceRef.orderByChild(DbRef.admin).equalTo(auth.requireUid).onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        _deviceList.add(DeviceModel.fromSnapshot(event.snapshot));
        _onDeviceAddedController!.add(_deviceList.toList());
        print('got it');
      }
    });

    final changedSubscription = _deviceRef.orderByChild(DbRef.admin).equalTo(auth.requireUid).onChildChanged.listen((event) {
      if (event.snapshot.exists) {
        final model = DeviceModel.fromSnapshot(event.snapshot);
        final i = _deviceList.indexWhere((element) => element.deviceKey == model.deviceKey);
        _deviceList[i] = model;
        _onDeviceAddedController!.add(_deviceList.toList());
        print('got i2t');
      }
    });

    _onDeviceAddedController!.onCancel = () {
      print('*** Firebase Device Subscription Closed *** ');
      addedSubscription.cancel();
      changedSubscription.cancel();
    };

    yield* _onDeviceAddedController!.stream;
  }

  void close(){
    _onDeviceAddedController?.close();
  }
}