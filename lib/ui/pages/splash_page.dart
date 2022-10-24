import 'package:flutter/material.dart';
import 'package:service_admin/ui/pages/auth_page.dart';
import 'package:service_admin/ui/pages/home_page.dart';
import 'package:service_admin/utils/utils.dart';

import '../../api/auth.dart';
import '../../api/di/locator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Auth auth;

  @override
  void initState() {
    auth = locator();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      if (auth.hasCurrentUser) {
        context.navigatePushReplace(const HomePage());
      } else {
        await auth.login("shub", '123456');
        if (!mounted) return;
        context.navigatePushReplace(const HomePage());

        // context.navigatePushReplace(const AuthPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
