import 'package:flutter/material.dart';
import 'package:service_admin/ui/pages/login/auth_page.dart';
import 'package:service_admin/ui/pages/home/home_page.dart';
import 'package:service_admin/api/utils.dart';
import 'package:service_admin/ui/ui_utils.dart';

import '../../../api/auth.dart';
import '../../../api/di/locator.dart';

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
        context.navigatePushReplace(HomePage.providerWrapped());
      } else {
        await auth.login("shub", '123456');
        if (!mounted) return;
        context.navigatePushReplace(HomePage.providerWrapped());

        // context.navigatePushReplace(const AuthPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SplashPage'),
      ),
      body: Container(),
    );
    // return Scaffold(
    //   body: Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );
  }

  Widget buildResponiveColorData() => SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  namedContainer("primary",
                      child: namedContainer("onPrimary", width: 100)),
                  namedContainer("secondary",
                      child: namedContainer("onSecondary", width: 100)),
                  namedContainer("tertiary",
                      child: namedContainer("onTertiary", width: 100)),
                  namedContainer("error",
                      child: namedContainer("onError", width: 100)),
                  namedContainer("background",
                      child: namedContainer("onBackground", width: 100)),
                  namedContainer("surface",
                      child: namedContainer("onSurface", width: 100)),
                  namedContainer("surfaceVariant",
                      child: namedContainer("onSurfaceVariant", width: 100)),
                  namedContainer("inverseSurface",
                      child: namedContainer("onInverseSurface", width: 100)),
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  namedContainer("primaryContainer",
                      child: namedContainer("onPrimaryContainer", width: 100)),
                  namedContainer("secondaryContainer",
                      child:
                          namedContainer("onSecondaryContainer", width: 100)),
                  namedContainer("tertiaryContainer",
                      child: namedContainer("onTertiaryContainer", width: 100)),
                  namedContainer("errorContainer",
                      child: namedContainer("onErrorContainer", width: 100)),
                  namedContainer("inversePrimary"),
                  namedContainer("shadow"),
                  namedContainer("outline"),
                ],
              ),
            )
          ],
        ),
      );

  Widget namedContainer(String name,
      {double? height, double? width, Widget? child}) {
    Color? textColor;

    if (name.startsWith("on")) {
      textColor = _getColor(name.substring(2).nonCapitalize());
    } else {
      textColor = _getColor("on${name.capitalize()}");
    }

    return Container(
      color: _getColor(name),
      key: Key(name),
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
                child: Text(
              name,
              style: TextStyle(color: textColor),
            )),
            // if (name == 'primary') namedContainer("secondary"),
            if (child != null) child
          ],
        ),
      ),
    );
  }

  Widget _getColorListView() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            "primaryContainer",
            "secondaryContainer",
            "tertiaryContainer",
            "errorContainer",
            "onPrimaryContainer",
            "onSecondaryContainer",
            "onTertiaryContainer",
            "onErrorContainer",
            "primary",
            "secondary",
            "tertiary",
            "error",
            "onPrimary",
            "onSecondary",
            "onTertiary",
            "onError",
            "surface",
            "surfaceVariant",
            "background",
            "onSurface",
            "onSurfaceVariant",
            "onBackground",
            "inverseSurface",
            "onInverseSurface",
            "shadow",
            "outline",
            "inversePrimary",
            "surfaceTint"
          ]
              .map((e) => Container(
                    color: _getColor(e),
                    height: 50,
                    child: Center(child: Text(e)),
                  ))
              .toList(growable: false),
        ),
      );

  Color? _getColor(String colorName) {
    switch (colorName) {
      case "primaryContainer":
        return Theme.of(context).colorScheme.primaryContainer;
      case "secondaryContainer":
        return Theme.of(context).colorScheme.secondaryContainer;
      case "tertiaryContainer":
        return Theme.of(context).colorScheme.tertiaryContainer;
      case "errorContainer":
        return Theme.of(context).colorScheme.errorContainer;
      case "onPrimaryContainer":
        return Theme.of(context).colorScheme.onPrimaryContainer;
      case "onSecondaryContainer":
        return Theme.of(context).colorScheme.onSecondaryContainer;
      case "onTertiaryContainer":
        return Theme.of(context).colorScheme.onTertiaryContainer;
      case "onErrorContainer":
        return Theme.of(context).colorScheme.onErrorContainer;
      case "primary":
        return Theme.of(context).colorScheme.primary;
      case "secondary":
        return Theme.of(context).colorScheme.secondary;
      case "tertiary":
        return Theme.of(context).colorScheme.tertiary;
      case "error":
        return Theme.of(context).colorScheme.error;
      case "onPrimary":
        return Theme.of(context).colorScheme.onPrimary;
      case "onSecondary":
        return Theme.of(context).colorScheme.onSecondary;
      case "onTertiary":
        return Theme.of(context).colorScheme.onTertiary;
      case "onError":
        return Theme.of(context).colorScheme.onError;
      case "surface":
        return Theme.of(context).colorScheme.surface;
      case "surfaceVariant":
        return Theme.of(context).colorScheme.surfaceVariant;
      case "background":
        return Theme.of(context).colorScheme.background;
      case "onSurface":
        return Theme.of(context).colorScheme.onSurface;
      case "onSurfaceVariant":
        return Theme.of(context).colorScheme.onSurfaceVariant;
      case "onBackground":
        return Theme.of(context).colorScheme.onBackground;
      case "inverseSurface":
        return Theme.of(context).colorScheme.inverseSurface;
      case "onInverseSurface":
        return Theme.of(context).colorScheme.onInverseSurface;
      case "shadow":
        return Theme.of(context).colorScheme.shadow;
      case "outline":
        return Theme.of(context).colorScheme.outline;
      case "inversePrimary":
        return Theme.of(context).colorScheme.inversePrimary;
      case "surfaceTint":
        return Theme.of(context).colorScheme.surfaceTint;
    }
    return null;
  }
}
