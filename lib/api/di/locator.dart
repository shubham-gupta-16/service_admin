import 'package:get_it/get_it.dart';
import 'package:service_admin/api/all_devices_connection.dart';
import 'package:service_admin/api/api_constants.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/new_device_connetor.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locator = GetIt.instance;

Future<void> initializeDependencyInjection() async {
  
  locator.registerSingletonAsync<SharedPreferences>(() => SharedPreferences.getInstance());
  locator.registerSingleton(DbRef.getRootRef());
  locator.registerSingleton(Auth(await locator.getAsync()));

  locator.registerSingleton(NewDeviceConnector(locator(), locator()));
  locator.registerSingleton(AllDevicesConnection(locator(), locator()));
  locator.registerSingleton(DeviceDataConnection(locator(), locator()));
}
