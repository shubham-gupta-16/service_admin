import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/event_log_listener.dart';
import 'package:service_admin/ui/item_layouts/event_item_layout.dart';
import 'package:service_admin/ui/sections/device_section.dart';
import 'package:service_admin/ui/widgets/chip_tab_bar.dart';
import 'package:service_admin/ui/widgets/text_elevated_button.dart';

import '../../api/models/event_model.dart';

class EventLogFragment extends StatefulWidget {
  const EventLogFragment({Key? key}) : super(key: key);

  @override
  State<EventLogFragment> createState() => _EventLogFragmentState();
}

class _EventLogFragmentState extends State<EventLogFragment>{
  late DeviceDataConnection dataConnection;
  late EventLogListener eventLogListener;
  late ChipTabController chipTabController;

  String currentDate = "";

  @override
  void initState() {
    chipTabController = ChipTabController();
    dataConnection = locator();
    eventLogListener = EventLogListener(dataConnection.dataRef);
    super.initState();
    eventLogListener.start();
  }



  @override
  void dispose() {
    eventLogListener.close();
    chipTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DeviceFragment.logs.title),
      ),
      body: FutureBuilder(
          future: eventLogListener.getDateList(),
          builder: (context, future) {
            if (future.data == null || future.requireData.isEmpty) {
              return const SizedBox();
            }
            currentDate = future.requireData[0].date;
            eventLogListener.setDate(1, currentDate);
            return Column(
              children: [
                ChipTabBar(
                  controller: chipTabController,
                  tabs: future.requireData
                      .map((e) => Text(e.date))
                      .toList(growable: false),
                  onChange: (index) {
                    eventLogListener.setDate(index, future.requireData[index].date);
                  },
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: eventLogListener.getStream,
                    builder: (context, snapshot) {
                      if (snapshot.data == null ||
                          snapshot.requireData.isEmpty) {
                        return const SizedBox();
                      }
                      return _EventListView(list: snapshot.requireData);
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class _EventListView extends StatefulWidget {
  final List<EventModel> list;

  const _EventListView({Key? key, required this.list}) : super(key: key);

  @override
  State<_EventListView> createState() => _EventListViewState();
}

class _EventListViewState extends State<_EventListView> {
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      interactive: true,
      child: ListView.builder(
        controller: controller,
        reverse: true,
        itemBuilder: (context, index) {
          final eventModel = widget.list[index];
          return EventItemLayout(
            eventModel: eventModel,
            onPressed: () {},
          );
        },
        itemCount: widget.list.length,
      ),
    );
  }
}
