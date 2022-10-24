import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/event_log_listener.dart';
import 'package:service_admin/ui/item_layouts/event_item_layout.dart';
import 'package:service_admin/ui/sections/device_section.dart';
import 'package:service_admin/utils/utils.dart';

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
    eventLogListener =
        EventLogListener(dataConnection.dataRef);
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
          return Scrollbar(
            interactive: true,
            child: ListView.builder(
              controller: scrollController,
              reverse: true,
              itemBuilder: (context, index) {
                final eventModel = snapshot.requireData.reversed.toList(growable: false)[index];
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
              itemCount: snapshot.requireData.length,
            ),
          );
        },
      ),
    );
  }
}
