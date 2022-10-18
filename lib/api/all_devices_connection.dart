

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'api_constants.dart';
import 'models/device_model.dart';

class AllDevicesConnection {

  final DatabaseReference _dbRef;
  AllDevicesConnection(this._dbRef);

  DatabaseReference get _deviceRef => _dbRef.child(DbRef.devices);

  StreamController<List<DeviceModel>>? _onDeviceAddedController;
  final List<DeviceModel> _deviceList = [];


  Stream<List<DeviceModel>> stream() async* {
    _deviceList.clear();
    _onDeviceAddedController = StreamController();
    final addedSubscription = _deviceRef.onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        _deviceList.add(DeviceModel.fromSnapshot(event.snapshot));
        _onDeviceAddedController!.add(_deviceList.toList());
        print('got it');
      }
    });

    final changedSubscription = _deviceRef.onChildChanged.listen((event) {
      if (event.snapshot.exists) {
        final i = _deviceList.indexWhere((element) => element.deviceKey == event.snapshot.key);
        _deviceList[i] = DeviceModel.fromSnapshot(event.snapshot);
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