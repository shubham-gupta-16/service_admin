import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'api_constants.dart';
import 'models/cmd_reply_model.dart';

class CommandHandler {
  final String admin;
  final DatabaseReference _dbRef;

  CommandHandler(this._dbRef, this.admin);

  StreamController<CmdReplyModel>? _replyController;

  Stream<CmdReplyModel> get replyStream => _replyController!.stream;

  void start() {
    _replyController = StreamController.broadcast();
    final commandReplySubscription = _dbRef
        .child(DbRef.command)
        .orderByChild("admin")
        .equalTo(admin)
        .onChildChanged
        .listen((event) {
      if (!event.snapshot.exists) return;
      print(event.snapshot.value);
      final cmdReply = CmdReplyModel.fromSnapshot(event.snapshot);
      _replyController?.add(cmdReply);
      event.snapshot.ref.update({"admin": "_$admin"});
      print(cmdReply);
    });
    _replyController?.onCancel = () {
      commandReplySubscription.cancel();
    };
  }

  void close() {
    _replyController?.close();
  }

  void runCommand(String device, String command) {
    _dbRef
        .child(DbRef.command)
        .push()
        .set({"admin": admin,
      "device": device,
      "command": command});
  }
}
