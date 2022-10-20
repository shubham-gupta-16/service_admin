import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/api_constants.dart';
import 'package:service_admin/firebase/database.dart';
import 'models/event_model.dart';

class EventLogListener {
  final DatabaseReference _dataRef;

  EventLogListener(this._dataRef);

  StreamController<List<EventModel>>? _controller;

  Stream<List<EventModel>> stream() async* {
    _controller = _dataRef
        .child(DbRef.logs)
        .stream<EventModel>(
            converter: (snapshot) => EventModel.fromSnapshot(snapshot));

    yield* _controller!.stream;
  }

  void close() {
    _controller?.close();
  }
}
