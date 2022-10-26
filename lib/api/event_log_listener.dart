import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:service_admin/api/api_constants.dart';
import 'package:service_admin/firebase/database.dart';
import 'models/event_model.dart';

class EventLogListener {
  final DatabaseReference _dataRef;

  EventLogListener(this._dataRef);

  static const _itemPerPage = 101;

  StreamController<List<EventModel>>? _controller;

  final List<EventModel> list = [];

  Stream<List<EventModel>>? get getStream => _controller?.stream;

  start() {
    _controller = StreamController.broadcast();
    final addedSubs = _dataRef
        .child(DbRef.logs)
        .orderByKey()
        .limitToLast(_itemPerPage).onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        if (list.isEmpty) {
          // list.add(EventModel.loader(event.snapshot.key!));
        }
        list.insert(0, EventModel.fromSnapshot(event.snapshot));
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
    if (list.length < 1) return;
    // if (list.isEmpty) return;
    final model = list[list.length - 2];
    if (model.event == -1) return;
    print("loadMore");
    print(model.timestampAsKey);
    print("********************");
    final snapshot = await _dataRef.child(DbRef.logs)
        .orderByKey()
        .endBefore(model.timestampAsKey.toString()).limitToLast(_itemPerPage).get();

    if (snapshot.exists){
      if (list.isNotEmpty && list.last.event == -1){
        // list.removeLast();
      }
      for (final s in snapshot.children.toList(growable: false).reversed){
        list.add(EventModel.fromSnapshot(s));
        print(s.key);
      }
      // list.add(EventModel.loader(list.last.timestampAsKey.toString()));
      _controller?.add(list);
    }
  }

  void close() {
    _controller?.close();
  }
}
