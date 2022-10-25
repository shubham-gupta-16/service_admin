import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/event_log_listener.dart';
import 'package:service_admin/ui/item_layouts/event_item_layout.dart';
import 'package:service_admin/ui/sections/device_section.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../api/models/event_model.dart';

class EventLogFragment extends StatefulWidget {
  const EventLogFragment({Key? key}) : super(key: key);

  @override
  State<EventLogFragment> createState() => _EventLogFragmentState();
}

class _EventLogFragmentState extends State<EventLogFragment> {
  late DeviceDataConnection dataConnection;
  late EventLogListener eventLogListener;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    dataConnection = locator();
    eventLogListener = EventLogListener(dataConnection.dataRef);
    super.initState();
    scrollController.addListener(_scrollListener);
    eventLogListener.start();
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
          if (snapshot.data == null) return const SizedBox();
          return _EventListView3(
              list: snapshot.requireData, controller: scrollController);
        },
      ),
    );
  }
}

class _EventListView3 extends StatelessWidget {
  final List<EventModel?> list;
  final ScrollController controller;

  const _EventListView3(
      {Key? key, required this.list, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      child: ListView.builder(
        controller: controller,
        reverse: true,
        itemBuilder: (context, index) {
          final eventModel = list.reversed.toList(growable: false)[index];
          final Widget view;
          if (eventModel == null) {
            view = const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            view = EventItemLayout(
              eventModel: eventModel,
              onPressed: () {},
            );
          }
          return StickyHeader(
            content: view,
            header: Container(
              child: Center(
                child: Container(
                  color: Colors.blue,
                  child: Text(
                    'Header #0',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: list.length,
      ),
    );
    ;
  }
}

class _EventListView2 extends StatelessWidget {
  final List<EventModel?> list;
  final ScrollController controller;

  const _EventListView2(
      {Key? key, required this.list, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // controller: controller,
      // reverse: true,
      slivers: list.map((eventModel) {
        return _header(child: Text("WOW"));
      }).toList(growable: false),
    );
  }

  Widget _header({required Widget child}) => SliverStickyHeader(
        // overlapsContent: true,
        header: Container(
          child: Center(
            child: Container(
              color: Colors.blue,
              child: Text(
                'Header #0',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => child,
            childCount: 4,
          ),
        ),
      );
}

class _EventListView extends StatelessWidget {
  final List<EventModel?> list;
  final ScrollController controller;

  const _EventListView({Key? key, required this.list, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      child: ListView.builder(
        controller: controller,
        reverse: true,
        itemBuilder: (context, index) {
          final eventModel = list.reversed.toList(growable: false)[index];
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
    );
    ;
  }
}
