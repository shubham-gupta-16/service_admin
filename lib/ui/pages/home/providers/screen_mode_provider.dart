import 'package:flutter/material.dart';

enum ScreenMode {
  small,
  medium,
  expanded
}

ScreenMode getScreenMode(BuildContext context){
  final isDesktop = MediaQuery.of(context).size.width > 600;
  return isDesktop? ScreenMode.expanded : ScreenMode.small;
}

class ScreenModeProvider extends ChangeNotifier {
  ScreenMode _mode = ScreenMode.small;

  setMode(ScreenMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }
  ScreenMode get mode => _mode;
}
