

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/api_constants.dart';
import 'models/event_model.dart';

class EventLogListener {

  final DatabaseReference _dbRef;
  final String deviceKey;

  EventLogListener(this._dbRef, this.deviceKey);

  StreamController<List<EventModel>>? _controller;
  final List<EventModel> _eventList = [];

  Stream<List<EventModel>> stream() async* {
    _eventList.clear();
    _controller = StreamController();
    final addedSubscription = _dbRef.child(DbRef.data).child(deviceKey).child(DbRef.log).onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        _eventList.add(EventModel.fromSnapshot(event.snapshot));
        _controller!.add(_eventList.toList());
      }
    });

    _controller!.onCancel = () {
      print('*** Firebase Device Subscription Closed *** ');
      addedSubscription.cancel();
    };

    yield* _controller!.stream;
  }

  void close(){
    _controller?.close();

  }
}