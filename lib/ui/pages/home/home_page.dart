import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/di/locator.dart';
import 'package:service_admin/ui/pages/home/mobile_home_page.dart';
import 'package:service_admin/ui/pages/home/providers/device_update_provider.dart';
import 'package:service_admin/ui/pages/home/providers/screen_mode_provider.dart';
import 'package:service_admin/ui/ui_utils.dart';

import 'web_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage._({Key? key}) : super(key: key);

  static Widget providerWrapped() => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: DeviceUpdateProvider()),
          ChangeNotifierProvider.value(value: ScreenModeProvider())
        ],
        child: const HomePage._(),
      );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DeviceDataConnection _dataConnection;
  StreamSubscription? _replySubs;

  @override
  void initState() {
    _dataConnection = locator();
    super.initState();
    _dataConnection.start();
    _replySubs = _dataConnection.replyStream.listen((reply) {
      context.showSnackBar(reply.code.name);
    });

  }

  @override
  void dispose() {
    _replySubs?.cancel();
    _dataConnection.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final mode = getScreenMode(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('tada');
      context.read<ScreenModeProvider>().setMode(getScreenMode(context));
    });

    if (mode == ScreenMode.expanded) {
      return const WebHomePage();
    }
    return const MobileHomePage();
  }


}
