import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

import '../../../api/models/event_model.dart';

class EventListView2 extends StatefulWidget {
  final List<EventModel> list;
  final ScrollController controller;
  final VoidCallback onScrolledToTop;

  const EventListView2(
      {Key? key,
      required this.list,
      required this.controller,
      required this.onScrolledToTop})
      : super(key: key);

  @override
  State<EventListView2> createState() => _EventListView2State();
}

class _EventListView2State extends State<EventListView2> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // widget.controller.jumpTo(widget.controller.position.maxScrollExtent);
    });
  }

  bool isUserScrolling = false;

  // print('reset');
  bool initialScroll = false;
  double lastExtent = 0;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    final List<String> dates = [];
    final List<List<EventModel>> subList = [];

    if (initialScroll){
      if (widget.controller.position.extentAfter == 0){
        widget.controller.jumpTo(widget.controller.position.pixels - 1);
      } else {
        widget.controller.jumpTo(widget.controller.position.pixels + 1);
      }
    }

    // if (initialScroll){
    //   print("Max:  ${widget.controller.position.maxScrollExtent}");
    //   final maxExtent = widget.controller.position.maxScrollExtent;
    //   if (maxExtent > lastExtent) {
    //     final extra = maxExtent - lastExtent;
    //     widget.controller.jumpTo(widget.controller.position.pixels + extra);
    //
    //     if (widget.controller.position.extentAfter == extra) {}
    //   }
    // }

    print(widget.list.last);
    String? date;

    int pos = -1;

    for (final item in widget.list) {
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

    return NotificationListener(
      onNotification: (nf) {
        print(nf.runtimeType);
        if (nf is UserScrollNotification) {
          if (nf.direction == ScrollDirection.idle) {
            print(
                "******************USER_SCROLLING_STOP*************************");
            isUserScrolling = false;
          } else {
            print("******************USER_SCROLLING*************************");
            isUserScrolling = true;
          }
        }

        if (nf is ScrollMetricsNotification) {
          if (initialScroll && nf.metrics.pixels == 0) {
            widget.onScrolledToTop();
          }
          print("Extent: $lastExtent, $initialScroll, $isUserScrolling");
          if (!isUserScrolling) {
            if (initialScroll) {
              // all here
              final maxExtent = nf.metrics.maxScrollExtent;
              if (maxExtent > lastExtent) {
                final extra = maxExtent - lastExtent;
                widget.controller.jumpTo(nf.metrics.pixels + extra);

                if (nf.metrics.extentAfter == extra) {}
              }
            } else {
              widget.controller.jumpTo(nf.metrics.maxScrollExtent);
              if (nf.metrics.extentAfter == 0) {
                initialScroll = true;
              }
              print("===============================");
            }
          }
          lastExtent = nf.metrics.maxScrollExtent;
          print("Extent: $lastExtent, ${nf.metrics.pixels}");
        }
        return true;
      },
      child: CustomScrollView(
        controller: widget.controller,
        // reverse: true,
        slivers: dates.map((date) {
          //todo logic tobe improved
          return _header(date: date, subList: subList[dates.indexOf(date)]);
        }).toList(growable: false),
      ),
    );
  }

  Widget _header({required String date, required List<EventModel> subList}) =>
      SliverStickyHeader(
        header: Align(
          alignment: Alignment.topCenter,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primaryContainer),
              child: Text(
                date,
                style: Theme.of(context).textTheme.overline?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              )),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final eventModel = subList[i];
              return Text(eventModel.text ?? "-");
            },
            childCount: subList.length,
          ),
        ),
      );
}
