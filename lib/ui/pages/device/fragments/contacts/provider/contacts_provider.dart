


import 'package:flutter/foundation.dart';
import 'package:service_admin/api/models/contact_model.dart';

class ContactsProvider extends ChangeNotifier {
  String _text = "";

  setSearchText(String text){
    _text = text.trim();
    notifyListeners();
  }

  List<ContactModel> getFilteredList(List<ContactModel> list){
    return list.where((element) => element.name.toLowerCase().contains(_text.toLowerCase()) || element.number.contains(_text)).toList(growable: false);
  }

}