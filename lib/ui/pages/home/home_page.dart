import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/ui/pages/home/mobile_home_page.dart';
import 'package:service_admin/ui/pages/home/providers/device_update_provider.dart';

import 'web_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage._({Key? key}) : super(key: key);

  static Widget providerWrapped() => ChangeNotifierProvider.value(
      value: DeviceUpdateProvider(),
      child: const HomePage._());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        if (isDesktop) {
          return const WebHomePage();
        }
        return const MobileHomePage();
      }),
    );
  }
}
