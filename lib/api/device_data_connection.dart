


import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/models/device_model.dart';

import 'api_constants.dart';

class DeviceDataConnection {

  final DatabaseReference _dbRef;
  DeviceDataConnection(this._dbRef);

  DeviceModel? _deviceModel;
  DeviceModel get deviceModel => _deviceModel!;
  DatabaseReference get _dataRef => _dbRef.child(DbRef.data).child(deviceModel.deviceKey);


  void setDevice(DeviceModel deviceModel){
    _deviceModel = deviceModel;
  }



}