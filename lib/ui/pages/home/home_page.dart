import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/all_devices_connection.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/ui/item_layouts/device_item_layout.dart';
import 'package:service_admin/ui/pages/add_device/add_device_page.dart';
import 'package:service_admin/ui/pages/login/auth_page.dart';
import 'package:service_admin/ui/pages/device/device_page.dart';
import 'package:service_admin/ui/pages/home/mobile_home_page.dart';
import 'package:service_admin/ui/pages/home/providers/device_update_provider.dart';
import 'package:service_admin/ui/pages/home/common_all_device_list_section.dart';
import 'package:service_admin/api/utils.dart';

import 'web_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DeviceDataConnection _dataConnection;

  @override
  void initState() {
    _dataConnection = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: DeviceUpdateProvider(),
      child: LayoutBuilder(builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        if (isDesktop) {
          return const WebHomePage();
        }
        return const MobileHomePage();
      }),
    );
  }
}
