import 'package:flutter/material.dart';

enum ScreenMode {
  small,
  medium,
  expanded;

  bool get isSmall => this == ScreenMode.small;
  bool get isMedium => this == ScreenMode.medium;
  bool get isExpanded => this == ScreenMode.expanded;

  bool get isSmallOrMedium => this == ScreenMode.small || this == ScreenMode.medium;
  bool get isMediumOrExpanded => this == ScreenMode.medium || this == ScreenMode.expanded;
}

ScreenMode getScreenMode(BuildContext context){
  final width = MediaQuery.of(context).size.width;
  return width < 600 ? ScreenMode.small : width > 840 ? ScreenMode.expanded : ScreenMode.medium;
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
