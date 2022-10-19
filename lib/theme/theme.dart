
import 'package:flutter/material.dart';

ThemeData getTheme(Brightness mode) => ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  brightness: mode,
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,

  ),
);


