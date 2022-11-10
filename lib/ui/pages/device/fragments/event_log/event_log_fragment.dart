import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/di/locator.dart';
import 'package:service_admin/api/event_log_listener.dart';
import 'package:service_admin/ui/item_layouts/event_item_layout.dart';
import 'package:service_admin/ui/pages/device/device_section.dart';
import 'package:service_admin/ui/pages/device/fragments/event_log/provider/event_filter_provider.dart';
import 'package:service_admin/ui/widgets/chip_tab_bar.dart';

import '../../../../../api/models/event_model.dart';

class EventLogFragment extends StatefulWidget {
  const EventLogFragment._({Key? key}) : super(key: key);

  static Widget providerWrapped() => ChangeNotifierProvider.value(
      value: EventFilterProvider(), child: const EventLogFragment._());

  @override
  State<EventLogFragment> createState() => _EventLogFragmentState();
}

class _EventLogFragmentState extends State<EventLogFragment> {
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
          title: Text(DeviceFragment.logs.title), actions: const [FilterSelector()]),
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
                    eventLogListener.setDate(
                        index, future.requireData[index].date);
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
                      return _EventListView(
                        list: snapshot.requireData,
                        onRemove: (int key) {
                          eventLogListener.removeLog(key);
                        },
                      );
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
  final void Function(int key) onRemove;

  const _EventListView({Key? key, required this.list, required this.onRemove})
      : super(key: key);

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
    final event = context.watch<EventFilterProvider>().event;
    final filteredList = event == 0 ? widget.list : widget.list.where((element) => element.event == event).toList();
    return ListView.builder(
      controller: controller,
      reverse: true,
      itemBuilder: (context, index) {
        final eventModel = filteredList[index];
        return Dismissible(
          key: Key(eventModel.timestampAsKey.toString()),
          onDismissed: (direction) {
            setState(() {
              widget.list.remove(eventModel);
              widget.onRemove(eventModel.timestampAsKey);
            });
          },
          child: EventItemLayout(
            eventModel: eventModel,
            onPressed: () {},
          ),
        );
      },
      itemCount: filteredList.length,
    );
  }
}

class FilterSelector extends StatelessWidget {
  const FilterSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventFilterProvider>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PopupMenuButton<int>(
        icon: _colorIcon(provider.event),
        onSelected: (int result) {
            provider.setEventType(result);
        },
        itemBuilder: (BuildContext context) => [
          0,
          1,
          8,
          16,
          64,
        ]
            .map((e) => PopupMenuItem<int>(
                  value: e,
                  child: Row(
                    children: [
                      _colorIcon(e),
                      const SizedBox(width: 8),
                      Text(EventModel.getEventName(e) ?? "All"),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _colorIcon(int event) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
          color: EventModel.getEventColor(event), shape: BoxShape.circle),
    );
  }
}
