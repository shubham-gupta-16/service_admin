import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/event_log_listener.dart';
import 'package:service_admin/ui/item_layouts/event_item_layout.dart';
import 'package:service_admin/ui/sections/device_section.dart';

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

  void _scrollListener(){
    if (scrollController.position.extentAfter == 0){
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
          return _EventListView(list: snapshot.requireData, controller: scrollController);
        },
      ),
    );
  }
}

class _EventListView extends StatelessWidget {
  final List<EventModel?> list;
  final ScrollController controller;
  const _EventListView({Key? key, required this.list, required this.controller}) : super(key: key);

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
            onPressed: (){},
          );
        },
        itemCount: list.length,
      ),
    );;
  }
}


Widget _header({required Widget child}) =>
    SliverStickyHeader(
      header: Container(
        height: 60.0,
        color: Colors.lightBlue,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'Header #0',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, i) =>
              child,
          childCount: 4,
        ),
      ),
    );
