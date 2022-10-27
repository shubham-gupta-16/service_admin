import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/auth.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/utils/utils.dart';

import '../../widgets/stack_page_transition.dart';
import '../add_device/add_device_page.dart';
import '../login/auth_page.dart';
import '../device/device_page.dart';
import 'common_all_device_list_section.dart';
import 'providers/device_update_provider.dart';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: const CommonAllDeviceListSection(isDesktop: false,),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.navigatePush(const AddDevicePage());
        },
      ),
    );
  }
}
