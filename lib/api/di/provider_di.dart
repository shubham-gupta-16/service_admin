

import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:service_admin/api/all_devices_connection.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/api/device_data_connection.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton(FirebaseDatabase.instance.ref());
  locator.registerSingleton(Auth());
  locator.registerSingleton(AllDevicesConnection(locator()));
  locator.registerSingleton(DeviceDataConnection(locator()));
}