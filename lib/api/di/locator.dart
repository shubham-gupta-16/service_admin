

import 'package:get_it/get_it.dart';
import 'package:service_admin/api/all_devices_connection.dart';
import 'package:service_admin/api/api_constants.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/api/device_data_connection.dart';

final locator = GetIt.instance;

void initializeDependencyInjection() {
  locator.registerSingleton(DbRef.getFirebaseRef());
  locator.registerSingleton(Auth());
  locator.registerSingleton(AllDevicesConnection(locator(), locator()));
  locator.registerSingleton(DeviceDataConnection(locator()));
}