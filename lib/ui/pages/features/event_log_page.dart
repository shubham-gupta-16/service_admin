import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/provider_di.dart';
import 'package:service_admin/api/event_log_listener.dart';
import 'package:service_admin/ui/item_layouts/event_item_layout.dart';

class EventLogPage extends StatefulWidget {
  const EventLogPage({Key? key}) : super(key: key);

  @override
  State<EventLogPage> createState() => _EventLogPageState();
}

class _EventLogPageState extends State<EventLogPage> {
  late DeviceDataConnection dataConnection;
  late EventLogListener eventLogListener;
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    dataConnection = locator();
    eventLogListener =
        EventLogListener(locator(), dataConnection.deviceModel.deviceKey);
    super.initState();
  }

  @override
  void dispose() {
    eventLogListener.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Logs'),
      ),
      body: StreamBuilder(
        stream: eventLogListener.stream(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return const SizedBox();
          return Scrollbar(
            interactive: true,
            child: ListView.builder(
              reverse: true,
              itemBuilder: (context, index) {
                final eventModel = snapshot.requireData[index];
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
