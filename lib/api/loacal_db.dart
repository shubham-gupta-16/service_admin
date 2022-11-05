

import 'package:service_admin/api/models/call_history_model.dart';
import 'package:service_admin/api/models/contact_model.dart';

class LocalDb {
  final _callHistoryMap = <String, List<CallHistoryModel>>{};
  final _contactsMap = <String, List<ContactModel>>{};

  //CALL HISTORY
  void updateCallHistory(String deviceKey, List<CallHistoryModel> list){
    _callHistoryMap[deviceKey] = list;
  }
  void addCallHistory(String deviceKey, CallHistoryModel model){
    if (!_callHistoryMap.containsKey(deviceKey)) {
      _callHistoryMap[deviceKey] = [];
    }
    _callHistoryMap[deviceKey]?.add(model);
  }
  List<CallHistoryModel>? getCallHistory(String deviceKey){
    return _callHistoryMap[deviceKey];
  }

  // CONTACTS
  void updateContact(String deviceKey, List<ContactModel> list){
    _contactsMap[deviceKey] = list;
  }
  List<ContactModel>? getContacts(String deviceKey){
    return _contactsMap[deviceKey];
  }
}