import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/all_devices_connection.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/provider_di.dart';
import 'package:service_admin/ui/item_layouts/device_item_layout.dart';
import 'package:service_admin/ui/pages/device_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      body: StreamBuilder(
          stream: connection.stream(),
          builder: (context, snapshot) {
            // print(snapshot);
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final deviceModel = snapshot.requireData[index];
                  return DeviceItemLayout(
                    deviceModel: deviceModel,
                    onPressed: () {
                      locator<DeviceDataConnection>()
                          .setDevice(deviceModel);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DevicePage()),
                      );
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
    );
  }
}
