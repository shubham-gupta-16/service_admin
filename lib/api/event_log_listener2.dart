import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/api_constants.dart';
import 'package:service_admin/firebase/database.dart';
import 'models/event_model.dart';

class EventLogListener {
  final DatabaseReference _dataRef;

  EventLogListener(this._dataRef);

  static const _itemPerPage = 100;

  StreamController<List<EventModel?>>? _controller;

  final List<EventModel?> list = [];

  Stream<List<EventModel?>>? get getStream => _controller?.stream;

  start() {
    _controller = StreamController.broadcast();
    final addedSubs = _dataRef
        .child(DbRef.logs)
        .orderByKey()
        .limitToLast(_itemPerPage).onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        if (list.isEmpty) {
          list.add(null);
        }
        list.add(EventModel.fromSnapshot(event.snapshot));
        _controller?.add(list);
      }
    });
    _controller?.onCancel = (){
      addedSubs.cancel();
    };
    // _controller = _dataRef
    //     .child(DbRef.logs)
    //     .orderByKey()
    //     .limitToLast(20)
    //     .stream<EventModel>(
    //         converter: (snapshot) => EventModel.fromSnapshot(snapshot));
    //
    // yield* _controller!.stream;
  }
  Future<void> loadMore() async {
    if (list.length < 2) return;
    final model = list[1];
    if (model == null) return;
    print("loadMore");
    print(model.timestampAsKey);
    print("********************");
    final snapshot = await _dataRef.child(DbRef.logs)
        .orderByKey()
        .endBefore(model.timestampAsKey.toString()).limitToLast(_itemPerPage).get();

    if (snapshot.exists){
      if (list.isNotEmpty && list.first == null){
        list.removeAt(0);
      }
      for (final s in snapshot.children.toList(growable: false).reversed){
        list.insert(0, EventModel.fromSnapshot(s));
        print(s.key);
      }
      list.insert(0, null);
      _controller?.add(list);
    }
  }

  void close() {
    _controller?.close();
  }
}
