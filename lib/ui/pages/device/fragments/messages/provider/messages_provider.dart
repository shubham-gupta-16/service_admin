


import 'package:flutter/foundation.dart';
import 'package:service_admin/api/models/contact_model.dart';

class MessagesProvider extends ChangeNotifier {
  int _event = 0;

  setEventType(int event){
    if (_event == event) return;
    _event = event;
    notifyListeners();
  }

  int get event => _event;

}