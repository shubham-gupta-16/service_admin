

import 'package:flutter/foundation.dart';
import 'package:service_admin/api/models/device_model.dart';

class DeviceUpdateProvider extends ChangeNotifier{
  DeviceModel? _deviceModel;

  setDevice(DeviceModel? deviceModel){
    _deviceModel = deviceModel;
    notifyListeners();
  }

  bool get hasDeviceModel => _deviceModel != null;
  DeviceModel? get deviceModel => _deviceModel;
  DeviceModel get requireDeviceModel => _deviceModel!;

}