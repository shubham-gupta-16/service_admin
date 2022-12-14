import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/command_handler.dart';
import 'package:service_admin/api/loacal_db.dart';
import 'package:service_admin/api/models/cmd_reply_model.dart';
import 'package:service_admin/api/models/contact_model.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/api/models/message_model.dart';

import 'api_constants.dart';
import 'auth.dart';
import 'models/call_history_model.dart';

class DeviceDataConnection {
  final DatabaseReference _dbRef;
  final Auth auth;
  final db = LocalDb();
  late final CommandHandler commandHandler;

  DeviceDataConnection(this._dbRef, this.auth){
    commandHandler = CommandHandler(_dbRef, auth.requireUsername);
  }

  DeviceModel? deviceModel;

  DeviceModel get requireDeviceModel => deviceModel!;

  String get deviceKey => requireDeviceModel.deviceKey;

  DatabaseReference get dataRef =>
      DbRef.getDataRef(deviceKey, auth.requireUsername);

  Stream<CmdReplyModel> get replyStream => commandHandler.replyStream;

  void start() {
    print("start ----------------------------------------------");
    commandHandler.start();
  }

  void setDevice(DeviceModel deviceModel) {
    this.deviceModel = deviceModel;
  }

  void runCommand(String command) {
    commandHandler.runCommand(deviceKey, command);
  }

  void close() {
    print("close -------------------------------------------------");
    commandHandler.close();
    deviceModel = null;
  }

  Future<List<CallHistoryModel>> getCallHistory() async {
    print("called");
    final localCallHistory = db.getCallHistory(deviceKey);
    try {
      if (localCallHistory != null && localCallHistory.isNotEmpty) {
        print('more call history...');
        final more = await _getCallHistory(localCallHistory.first.timestamp);
        for (final i in more) {
          print(i);
          localCallHistory.insert(0, i);
        }
        return localCallHistory;
      }
      print('all call history');
      final list = await _getCallHistory(null);
      db.updateCallHistory(deviceKey, list);
      if (list.isEmpty) {
        return Future.error("Empty Result");
      }
      return list;
    } catch (e) {
      return Future.error("Network Error");
    }
  }

  Future<List<ContactModel>> getContacts() async {
    final localContacts = db.getContacts(deviceKey);
    if (localContacts != null) {
      await Future.delayed(const Duration(milliseconds: 100));
      return localContacts;
    }
    try {
      final snapshot = await dataRef.child(DbRef.contacts).get();
      if (!snapshot.exists) return Future.error("Not Found");
      final list = snapshot.children
          .map((e) => ContactModel.fromSnapshot(e))
          .toList(growable: false);
      db.updateContact(deviceKey, list);
      return list;
    } catch (e) {
      return Future.error("Not Found");
    }
  }

  Future<List<MessageModel>> getMessages() async {
    final localMessages = db.getMessages(deviceKey);
    if (localMessages != null) {
      await Future.delayed(const Duration(milliseconds: 100));
      return localMessages;
    }
    try {
      final snapshot = await dataRef.child(DbRef.messages).get();
      if (!snapshot.exists) return Future.error("Not Found");
      final List<MessageModel> list = [];
      for (final e in snapshot.children) {
        list.insert(0, MessageModel.fromSnapshot(e));
      }
      db.updateMessages(deviceKey, list);
      return list;
    } catch (e) {
      return Future.error("Not Found");
    }
  }

  Future<List<CallHistoryModel>> _getCallHistory(int? timestamp) async {
    final snapshot = timestamp != null
        ? await dataRef
            .child(DbRef.callHistory)
            .orderByKey()
            .startAfter((timestamp + 1).toString())
            .get()
        : await dataRef.child(DbRef.callHistory).get();
    print('.................');
    if (!snapshot.exists) [];
    final List<CallHistoryModel> list = [];
    for (final s in snapshot.children) {
      list.insert(0, CallHistoryModel.fromSnapshot(s));
    }
    print(list);
    return list;
  }
}
