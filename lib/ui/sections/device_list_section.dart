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
import 'package:service_admin/utils/utils.dart';

class DevicesSection extends StatefulWidget {
  final Function(DeviceModel deviceModel) onDeviceSelected;
  final bool isDesktop;
  const DevicesSection({super.key, required this.onDeviceSelected, required this.isDesktop});

  @override
  State<DevicesSection> createState() => _DevicesSectionState();
}

class _DevicesSectionState extends State<DevicesSection> {
  late AllDevicesConnection connection;

  @override
  void initState() {
    connection = locator();
    super.initState();
  }

  @override
  void dispose() {
    connection.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDesktop ? Theme.of(context).colorScheme.surface : null,
      appBar: AppBar(
        leading: const SizedBox(),
        leadingWidth: 0,
        title: const Text('Devices'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: (){
            locator<Auth>().logout();
            context.navigatePushReplace(const AuthPage());
          }, icon: const Icon(Icons.login_outlined))
        ],
      ),
      body: StreamBuilder(
          stream: connection.stream(),
          builder: (context, snapshot) {
            // print(snapshot);
            if (snapshot.data != null) {
              final dataConn = locator<DeviceDataConnection>();
              return ListView.builder(
                itemBuilder: (context, index) {
                  final deviceModel = snapshot.requireData[index];
                  print(deviceModel.name);
                  print (dataConn.deviceModel?.name);
                  print("-----------------------------------");
                  return DeviceItemLayout(
                    deviceModel: deviceModel,
                    isSelected: deviceModel.deviceKey == dataConn.deviceModel?.deviceKey,
                    onPressed: () {
                      // setState(() {
                        print("pressed");
                        dataConn.setDevice(deviceModel);
                        widget.onDeviceSelected(deviceModel);
                      // });
                    },
                  );
                },
                itemCount: snapshot.requireData.length,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.navigatePush(AddDevicePage());
        },),
    );
  }
}
