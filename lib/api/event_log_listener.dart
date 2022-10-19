import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/api_constants.dart';
import 'package:service_admin/firebase/database.dart';
import 'models/event_model.dart';

class EventLogListener {
  final DatabaseReference _dbRef;
  final String deviceKey;

  EventLogListener(this._dbRef, this.deviceKey);

  StreamController<List<EventModel>>? _controller;

  // final List<EventModel> _eventList = [];

  Stream<List<EventModel>> stream() async* {
    // _eventList.clear();
    _controller = FirebaseDatabase.instance.ref()
        .child(DbRef.data)
        .child(deviceKey)
        .child(DbRef.log)
        .stream<EventModel>(
            converter: (snapshot) => EventModel.fromSnapshot(snapshot));

    print("${DbRef.data}/$deviceKey/${DbRef.log}");

    yield* _controller!.stream;
  }

  void close() {
    _controller?.close();
  }
}
