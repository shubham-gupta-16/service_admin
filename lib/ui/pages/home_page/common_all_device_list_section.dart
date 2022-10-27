import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/all_devices_connection.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/ui/item_layouts/device_item_layout.dart';

import 'providers/device_update_provider.dart';

class CommonAllDeviceListSection extends StatefulWidget {
  final bool isDesktop;

  const CommonAllDeviceListSection({super.key, required this.isDesktop});

  @override
  State<CommonAllDeviceListSection> createState() => _CommonAllDeviceListSectionState();
}

class _CommonAllDeviceListSectionState extends State<CommonAllDeviceListSection> {
  late AllDevicesConnection connection;

  @override
  void initState() {
    connection = locator();
    super.initState();
    connection.start();
    print("**********iNIT***********");
  }

  @override
  void dispose() {
    // connection.close();
    print("**********DISPOSE***********");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connection.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.requireData.isEmpty){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return _DevicesListView(list: snapshot.requireData, isDesktop: widget.isDesktop,);
        });
  }
}

class _DevicesListView extends StatelessWidget {

  final List<DeviceModel> list;
  final bool isDesktop;
  const _DevicesListView({Key? key, required this.list, required this.isDesktop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("build -> Device List");
    final dataConn = locator<DeviceDataConnection>();
    final deviceUpdateProvider = context.watch<DeviceUpdateProvider>();
    return ListView.builder(
      itemBuilder: (context, index) {
        final deviceModel = list[index];
        return DeviceItemLayout(
          deviceModel: deviceModel,
          isSelected: isDesktop && deviceModel.deviceKey ==
              deviceUpdateProvider.deviceModel?.deviceKey,
          onPressed: () {
            print("pressed -> $deviceModel");
            dataConn.setDevice(deviceModel);
            deviceUpdateProvider.setDevice(deviceModel);
          },
        );
      },
      itemCount: list.length,
    );
  }
}
