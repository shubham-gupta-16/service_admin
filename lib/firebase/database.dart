import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

/*T printFirst<T>(List<T> lst) {
  //List of generic type taken as function argument
  T first = lst[0]; //Generic type as local variable
  print(first);
  return first; //Generic type as return value
}*/

class ChildEventListener {
  final void Function(DataSnapshot snapshot)? onChildAdded;
  final void Function(DataSnapshot snapshot)? onChildChanged;
  final void Function(DataSnapshot snapshot)? onChildMoved;
  final void Function(DataSnapshot snapshot)? onChildRemoved;

  StreamSubscription<DatabaseEvent>? onChildAddedSubs;
  StreamSubscription<DatabaseEvent>? onChildChangedSubs;
  StreamSubscription<DatabaseEvent>? onChildMovedSubs;
  StreamSubscription<DatabaseEvent>? onChildRemovedSubs;

  ChildEventListener(
      {this.onChildAdded,
      this.onChildChanged,
      this.onChildMoved,
      this.onChildRemoved});

  void cancel() {
    onChildAddedSubs?.cancel();
    onChildChangedSubs?.cancel();
    onChildMovedSubs?.cancel();
    onChildRemovedSubs?.cancel();
  }
}

extension FirebaseQuery on Query {
  StreamController<List<T>> stream<T>(
      {required T Function(DataSnapshot snapshot) converter,
      required bool finder(T p1, T p2)}) {
    final streamController = StreamController<List<T>>();
    final List<T> list = [];
    final ca = onChildEventListener(ChildEventListener(
      onChildAdded: (snapshot) {
        list.add(converter(snapshot));
        streamController.add(list);
      },
      onChildChanged: (snapshot) {
        final model = converter(snapshot);
        final i = list.indexWhere((element) => finder(element, model));
        if (i >= 0){
          list[i] = model;
          streamController.add(list);
        }
      },
    ));
    streamController.onCancel = () {
      ca.cancel();
    };
    return streamController;
  }

  ChildEventListener onChildEventListener(
      ChildEventListener childEventListener) {
    if (childEventListener.onChildAdded != null) {
      childEventListener.onChildAddedSubs = onChildAdded.listen((event) {
        if (event.snapshot.exists) {
          childEventListener.onChildAdded!(event.snapshot);
        }
      });
    }
    if (childEventListener.onChildChanged != null) {
      childEventListener.onChildChangedSubs = onChildChanged.listen((event) {
        if (event.snapshot.exists) {
          childEventListener.onChildChanged!(event.snapshot);
        }
      });
    }
    if (childEventListener.onChildMoved != null) {
      childEventListener.onChildMovedSubs = onChildMoved.listen((event) {
        if (event.snapshot.exists) {
          childEventListener.onChildMoved!(event.snapshot);
        }
      });
    }
    if (childEventListener.onChildRemoved != null) {
      childEventListener.onChildRemovedSubs = onChildRemoved.listen((event) {
        if (event.snapshot.exists) {
          childEventListener.onChildRemoved!(event.snapshot);
        }
      });
    }
    return childEventListener;
  }
}
