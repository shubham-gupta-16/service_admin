


import 'package:flutter/foundation.dart';

class CallHistoryProvider extends ChangeNotifier {
  int _type = 0;
  int get type => _type;

  setTypeByIndex(int index) {
    _type = _getTypeByIndex(index);
    notifyListeners();
  }

  final typeFilterList = ['All', 'Received', 'Dialed', 'Missed', 'Rejected'];

  int _getTypeByIndex(int index) {
    switch (index) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 3;
      case 4:
        return 5;
      default:
        return 0;
    }
  }
}