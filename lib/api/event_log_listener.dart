import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:service_admin/api/api_constants.dart';
import 'package:service_admin/api/models/events_date_model.dart';
import 'models/event_model.dart';

class EventLogListener {
  final DatabaseReference _dataRef;
  final df = DateFormat("dd-MM-yyyy");

  EventLogListener(this._dataRef);

  static const _itemPerPage = 101;

  StreamController<List<EventModel>>? _controller;

  final List<EventModel> list = [];

  Stream<List<EventModel>>? get getStream => _controller?.stream;

  Future<List<EventsDateModel>> getDateList() async {
    final snapshot = await _dataRef.child(DbRef.logsIndex).get();
    if (!snapshot.exists) return Future.error("No Records");
    final List<EventsDateModel> list = [];
    for(final s in snapshot.children){
      list.insert(0, EventsDateModel.fromSnapshot(s));
    }
    return list;
  }

  String? globalDate;
  Future<void> setDate(int index, String date) async {
    globalDate = date;
    list.clear();
    _notify();
    final snapshot = await _dataRef.child(DbRef.logs).child(globalDate!)/*
        .orderByKey()
        .endBefore(model.timestampAsKey.toString()).limitToLast(_itemPerPage)*/.get();
    if (!snapshot.exists) return;
      if (list.isNotEmpty && list.last.event == -1){
        // list.removeLast();
      }

      for (final s in snapshot.children.toList(growable: false).reversed){
        list.add(EventModel.fromSnapshot(s));
      }
      // list.add(EventModel.loader(list.last.timestampAsKey.toString()));
    _notify();
  }

  void _notify(){
    print("nofify ${list.length}");
    _controller?.add(list);
  }

  start() {
    _controller = StreamController.broadcast();
    list.clear();
    /*final addedSubs = _dataRef
        .child(DbRef.logs)
        .orderByKey()
        .limitToLast(_itemPerPage).onChildAdded.listen((event) {
      if (event.snapshot.exists) {
        if (list.isEmpty) {
          // list.add(EventModel.loader(event.snapshot.key!));
        }
        list.insert(0, EventModel.fromSnapshot(event.snapshot));
        _controller?.add(_group);
      }
    });
    _controller?.onCancel = (){
      addedSubs.cancel();
    };*/

    // _controller = _dataRef
    //     .child(DbRef.logs)
    //     .orderByKey()
    //     .limitToLast(20)
    //     .stream<EventModel>(
    //         converter: (snapshot) => EventModel.fromSnapshot(snapshot));
    //
    // yield* _controller!.stream;
  }

  // Map<String, List<EventModel>> get _group {
  //   final map = HashMap<String, List<EventModel>>();
  //   String date = "";
  //
  //   for (final e in list){
  //     final newDate = _getDate(e);
  //     if (newDate != date){
  //       date = newDate;
  //       map[date] = [];
  //     }
  //     map[date]?.add(e);
  //   }
  //
  //   return map;
  // }

  String _getDate(EventModel e){
    return df.format(DateTime.fromMillisecondsSinceEpoch(e.timestampAsKey));
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
      _notify();
    }
  }

  void close() {
    _controller?.close();
  }
}
