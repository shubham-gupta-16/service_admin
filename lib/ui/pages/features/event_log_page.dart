

import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/provider_di.dart';
import 'package:service_admin/api/event_log_listener.dart';

class EventLogPage extends StatefulWidget {
  const EventLogPage({Key? key}) : super(key: key);

  @override
  State<EventLogPage> createState() => _EventLogPageState();
}

class _EventLogPageState extends State<EventLogPage> {

  late DeviceDataConnection dataConnection;
  late EventLogListener eventLogListener;

  @override
  void initState() {
    dataConnection = locator();
    eventLogListener = EventLogListener(locator(), dataConnection.deviceModel.deviceKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Logs'),
      ),
    );
  }
}
