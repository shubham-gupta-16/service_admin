import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/event_log_listener.dart';
import 'package:service_admin/ui/item_layouts/event_item_layout.dart';
import 'package:service_admin/ui/sections/device_section.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../api/models/event_model.dart';
import 'list/event_list_view2.dart';
import 'list/event_list_view3.dart';

class EventLogFragment extends StatefulWidget {
  const EventLogFragment({Key? key}) : super(key: key);

  @override
  State<EventLogFragment> createState() => _EventLogFragmentState();
}

class _EventLogFragmentState extends State<EventLogFragment> {
  late DeviceDataConnection dataConnection;
  late EventLogListener eventLogListener;
  late ScrollController scrollController;
  late ItemPositionsListener itemPositionListener;

  @override
  void initState() {
    scrollController = ScrollController();
    itemPositionListener = ItemPositionsListener.create();
    dataConnection = locator();
    eventLogListener = EventLogListener(dataConnection.dataRef);
    super.initState();
    scrollController.addListener(_scrollListener);
    eventLogListener.start();

    itemPositionListener.itemPositions.addListener(() {
      if (itemPositionListener.itemPositions.value.last.itemTrailingEdge < 1) {
        // print("bottom?" +
        //     _itemPositionsListener.itemPositions.value.last.itemTrailingEdge.toString() +
        //     '    ---- > ' +
        //     _itemPositionsListener.itemPositions.value.last.index.toString());
        if (itemPositionListener.itemPositions.value.last.index > 1) {
          //print('fetch');
          eventLogListener.loadMore();
        }
      }
    });
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter == 0) {
      eventLogListener.loadMore();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    eventLogListener.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DeviceFragment.logs.title),
      ),
      body: StreamBuilder(
        stream: eventLogListener.getStream,
        builder: (context, snapshot) {
          if (snapshot.data == null ||
              snapshot.requireData.isEmpty ||
              (snapshot.requireData.first == null &&
                  snapshot.requireData.length == 1)) return const SizedBox();

          return StickyDateListView(
            list: snapshot.requireData,
            header: (String value) => Align(
              alignment: Alignment.topCenter,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.primaryContainer),
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.overline?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer),
                  )),
            ),
            onLoadMore: () async {
              eventLogListener.loadMore();
            },
          );
          // return EventListView2(
          //     list: snapshot.requireData.reversed.toList(),
          //     controller: scrollController,
          //     onScrolledToTop: () {
          //       eventLogListener.loadMore();
          //       print('######################################################');
          //     });

          // return _EventListView5(list: snapshot.requireData.reversed.toList(), controller: itemPositionListener,
          //     onScrolledToTop: () {
          //       eventLogListener.loadMore();
          //     });

          // return _EventListView(list: snapshot.requireData, controller: scrollController);
        },
      ),
    );
  }
}

class _EventListView6 extends StatelessWidget {
  final List<EventModel> list;
  final ItemPositionsListener controller;
  final VoidCallback onScrolledToTop;

  const _EventListView6(
      {Key? key,
      required this.list,
      required this.controller,
      required this.onScrolledToTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return NotificationListener(
      onNotification: (nf) {
        // print(nf.runtimeType);

        if (nf is ScrollMetricsNotification) {
          print(nf.metrics);
          if (nf.metrics.extentAfter == 0) {
            print("##################################################");
            print(list);
            onScrolledToTop();
          }
        }
        // print(nf.runtimeType);
        return true;
      },
      child: StickyGroupedListView<EventModel, String>(
        elements: list,
        groupBy: (eventModel) => formatter.format(
            DateTime.fromMillisecondsSinceEpoch(eventModel.timestampAsKey)),
        groupSeparatorBuilder: (eventModel) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primaryContainer),
            child: Text(
              formatter.format(DateTime.fromMillisecondsSinceEpoch(
                  eventModel.timestampAsKey)),
              style: Theme.of(context).textTheme.overline?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            )),
        itemComparator: (e1, e2) =>
            e1.timestampAsKey.compareTo(e2.timestampAsKey),
        stickyHeaderBackgroundColor: Colors.transparent,
        order: StickyGroupedListOrder.DESC,
        reverse: true,
        itemBuilder: (context, eventModel) {
          return EventItemLayout(
            eventModel: eventModel,
            onPressed: () {},
          );
        },
      ),
    );
  }
}

class _EventListView5 extends StatelessWidget {
  final List<EventModel> list;
  final ItemPositionsListener controller;
  final VoidCallback onScrolledToTop;

  const _EventListView5(
      {Key? key,
      required this.list,
      required this.controller,
      required this.onScrolledToTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return NotificationListener(
      onNotification: (nf) {
        // print(nf.runtimeType);

        if (nf is ScrollMetricsNotification) {
          print(nf.metrics);
          if (nf.metrics.extentAfter == 0) {
            print("##################################################");
            print(list);
            onScrolledToTop();
          }
        }
        // print(nf.runtimeType);
        return true;
      },
      child: StickyGroupedListView<EventModel, String>(
        elements: list,
        groupBy: (eventModel) => formatter.format(
            DateTime.fromMillisecondsSinceEpoch(eventModel.timestampAsKey)),
        groupSeparatorBuilder: (eventModel) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primaryContainer),
            child: Text(
              formatter.format(DateTime.fromMillisecondsSinceEpoch(
                  eventModel.timestampAsKey)),
              style: Theme.of(context).textTheme.overline?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            )),
        itemComparator: (e1, e2) =>
            e1.timestampAsKey.compareTo(e2.timestampAsKey),
        stickyHeaderBackgroundColor: Colors.transparent,
        order: StickyGroupedListOrder.DESC,
        reverse: true,
        itemBuilder: (context, eventModel) {
          return EventItemLayout(
            eventModel: eventModel,
            onPressed: () {},
          );
        },
      ),
    );
  }
}

class _EventListView4 extends StatelessWidget {
  final List<EventModel> list;
  final ScrollController controller;

  const _EventListView4(
      {Key? key, required this.list, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return GroupedListView<EventModel, String>(
      elements: list,
      floatingHeader: true,
      groupBy: (eventModel) => formatter.format(
          DateTime.fromMillisecondsSinceEpoch(eventModel.timestampAsKey ?? 0)),
      groupSeparatorBuilder: (value) =>
          // Text(value),
          Container(
              alignment: Alignment.topCenter,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.primaryContainer),
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.overline?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ))),
      itemComparator: (e1, e2) =>
          e1.timestampAsKey.compareTo(e2.timestampAsKey),
      stickyHeaderBackgroundColor: Colors.transparent,
      useStickyGroupSeparators: true,
      order: GroupedListOrder.DESC,
      controller: controller,
      reverse: true,
      itemBuilder: (context, eventModel) {
        return EventItemLayout(
          eventModel: eventModel,
          onPressed: () {},
        );
      },
    );
  }
}

class _EventListView3 extends StatelessWidget {
  final List<EventModel> list;
  final ScrollController? controller;

  const _EventListView3(
      {Key? key, required this.list, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final map = HashMap<String, List<EventModel?>>();
    final List<String> dates = [];
    final List<List<EventModel>> subList = [];
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    String? date;

    int pos = -1;

    for (final item in list) {
      final newDate = formatter
          .format(DateTime.fromMillisecondsSinceEpoch(item.timestampAsKey));
      if (newDate != date) {
        date = newDate;
        dates.add(date);
        subList.add([]);
        pos++;
      }
      subList[pos].add(item);
    }

    // print(list.last);
    // String date = formatter.format(
    //     DateTime.fromMillisecondsSinceEpoch(list.first!.timestampAsKey));
    //
    // for (final item in list) {
    //   if (item != null) {
    //     date = formatter
    //         .format(DateTime.fromMillisecondsSinceEpoch(item.timestampAsKey));
    //   }
    //   if (!map.containsKey(date)) {
    //     map[date] = [];
    //   }
    //   map[date]?.add(item);
    // }

    // return _EventListView(list: snapshot.requireData, controller: scrollController);

    return ListView(
      controller: controller,
      reverse: true,
      children: dates.map((e) {
        final sl = subList[dates.indexOf(e)];
        return StickyHeader(
          content: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final eventModel = sl.reversed.toList(growable: false)[index];
              return EventItemLayout(
                eventModel: eventModel,
                onPressed: () {},
              );
            },
            itemCount: sl.length,
          ),
          header: Container(
            child: Center(
              child: Container(
                color: Colors.blue,
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }

  Widget _groupedList(List<EventModel> list) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final eventModel = list.reversed.toList(growable: false)[index];
        return EventItemLayout(
          eventModel: eventModel,
          onPressed: () {},
        );
      },
      itemCount: list.length,
    );
  }
}

class _EventListView extends StatelessWidget {
  final List<EventModel?> list;
  final ScrollController controller;

  const _EventListView({Key? key, required this.list, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (nf) {
        // print(nf.runtimeType);

        if (nf is ScrollMetricsNotification) {
          print(nf.metrics);
          if (nf.metrics.extentAfter == 0) {
            print("##################################################");
            print(list);
            // onScrolledToTop();
          }
        }
        // print(nf.runtimeType);
        return true;
      },
      child: Scrollbar(
        interactive: true,
        child: ListView.builder(
          controller: controller,
          reverse: true,
          itemBuilder: (context, index) {
            final eventModel = list[index];
            if (eventModel == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return EventItemLayout(
              eventModel: eventModel,
              onPressed: () {},
            );
          },
          itemCount: list.length,
        ),
      ),
    );
  }
}
