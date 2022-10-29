import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/utils.dart';
import 'package:service_admin/ui/ui_utils.dart';

import '../add_device/add_device_page.dart';
import '../login/auth_page.dart';
import '../device/device_page.dart';
import 'common_all_device_list_section.dart';
import 'providers/device_update_provider.dart';

class WebHomePage extends StatelessWidget {
  const WebHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        children: [
          const SizedBox(width: 400, child: _WebAllDeviceListSection()),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAlias,
                child: const _WebSelectedDeviceSection()),
          )
        ],
      ),
    );
  }
}

class _WebAllDeviceListSection extends StatelessWidget {
  const _WebAllDeviceListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: const SizedBox(),
        leadingWidth: 0,
        title: const Text('Devices'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                locator<Auth>().logout();
                context.navigatePushReplace(const AuthPage());
              },
              icon: const Icon(Icons.login_outlined))
        ],
      ),
      body: const CommonAllDeviceListSection(
        isDesktop: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //todo open in dialog
          context.navigatePush(const AddDevicePage());
        },
      ),
    );
  }
}

class _WebSelectedDeviceSection extends StatelessWidget {
  const _WebSelectedDeviceSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceUpdateProvider = context.watch<DeviceUpdateProvider>();
    return deviceUpdateProvider.hasDeviceModel
        ? DevicePage(
            key: Key(deviceUpdateProvider.requireDeviceModel.deviceKey),
            isDesktop: true,
          )
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.laptop_chromebook, size: 50,),
                SizedBox(width: 10),
                Icon(Icons.linear_scale, size: 50,),
                SizedBox(width: 10),
                Icon(Icons.android, size: 50,),
              ],
            ),
            const SizedBox(height: 20),
            Text('Select a device to make connection!', style: Theme.of(context).textTheme.headline6,),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 400
              ),
                child: Text(
                  'The project is in beta stage and still in development. Some features may not work properly.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,)),
          ],
        );
  }
}
