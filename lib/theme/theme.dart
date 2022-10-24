
import 'package:flutter/material.dart';

ColorScheme mySchemeLight(Brightness mode) => ColorScheme.fromSeed(seedColor: Colors.blue, brightness: mode).copyWith(
  surface: mode == Brightness.dark ? const Color(0xFF101316) : null,
  background: mode == Brightness.dark ? const Color(0xFF191E23) : null
);

ThemeData getTheme(Brightness mode, {bool useMaterial3 = true}) => ThemeData(
  brightness: mode,
  appBarTheme: AppBarTheme(
    surfaceTintColor: Colors.transparent,
    backgroundColor: mySchemeLight(mode).background,
    scrolledUnderElevation: 0,

  ),
  colorScheme: mySchemeLight(mode),
  toggleableActiveColor:
  useMaterial3 ? mySchemeLight(mode).primary : mySchemeLight(mode).secondary,
  primaryColor: mySchemeLight(mode).primary,
  primaryColorLight: Color.alphaBlend(
      Colors.white.withAlpha(0x66), mySchemeLight(mode).primary),
  primaryColorDark: Color.alphaBlend(
      Colors.black.withAlpha(0x66), mySchemeLight(mode).primary),
  secondaryHeaderColor: Color.alphaBlend(
      Colors.white.withAlpha(0xCC), mySchemeLight(mode).primary),
  scaffoldBackgroundColor: mySchemeLight(mode).background,
  canvasColor: mySchemeLight(mode).background,
  backgroundColor: mySchemeLight(mode).background,
  cardColor: mySchemeLight(mode).surface,
  bottomAppBarColor: mySchemeLight(mode).surface,
  dialogBackgroundColor: mySchemeLight(mode).surface,
  indicatorColor: mySchemeLight(mode).onPrimary,
  dividerColor: mySchemeLight(mode).onSurface.withOpacity(0.12),
  errorColor: mySchemeLight(mode).error,
  applyElevationOverlayColor: false,
  useMaterial3: useMaterial3,
  visualDensity: VisualDensity.standard,
);


