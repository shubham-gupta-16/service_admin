import 'package:flutter/material.dart';
import 'package:service_admin/api/all_devices_connection.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/ui/item_layouts/device_item_layout.dart';
import 'package:service_admin/ui/pages/add_device_page.dart';
import 'package:service_admin/ui/pages/auth_page.dart';
import 'package:service_admin/ui/pages/device_page.dart';
import 'package:service_admin/ui/sections/devices_section.dart';
import 'package:service_admin/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DeviceModel? deviceModel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        final devicesSection = DevicesSection(isDesktop: isDesktop, onDeviceSelected: (deviceModel) {
          locator<DeviceDataConnection>().setDevice(deviceModel);
          if (!isDesktop) {
            context.navigatePush(const DevicePage(isDesktop: false));
          } else {
            setState(() {
              this.deviceModel = deviceModel;
            });
          }
        });

        if (isDesktop) {
          return Scaffold(
            body: Row(
            children: [
              SizedBox(
                width: 400,
                  child: devicesSection),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: deviceModel != null ? DevicePage(isDesktop: true,): null),
              )
            ],
        ),
          );
        }

        return devicesSection;

      }
    );
  }
}
