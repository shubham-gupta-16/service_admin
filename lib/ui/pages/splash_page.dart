

import 'package:flutter/material.dart';
import 'package:service_admin/ui/pages/auth_page.dart';
import 'package:service_admin/ui/pages/home_page.dart';
import 'package:service_admin/utils/utils.dart';

import '../../api/auth.dart';
import '../../api/di/provider_di.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), (){
        if(auth.hasCurrentUser){
          context.navigatePushReplace(const HomePage());
        } else {
          context.navigatePushReplace(const AuthPage());
        }
      });

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
