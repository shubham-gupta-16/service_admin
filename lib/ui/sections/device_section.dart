
import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';

import '../../api/di/locator.dart';
import '../fragments/event_log_fragment.dart';
import '../widgets/text_elevated_button.dart';

enum DeviceFragment {
  logs,
  messages,
  callHistory,
  fileExplorer,
}

extension DeviceFragmentExt on DeviceFragment {
  String get title {
    switch (this) {
      case DeviceFragment.logs:
        return "Event Logs";
      case DeviceFragment.messages:
        return "Messages";
      case DeviceFragment.callHistory:
        return "Call History";
      case DeviceFragment.fileExplorer:
        return "File Explorer";
    }
  }

  Widget get widget {
    switch (this) {
      case DeviceFragment.logs:
        return const EventLogFragment();
      case DeviceFragment.messages:
        return const EventLogFragment();
      case DeviceFragment.callHistory:
        return const EventLogFragment();
      case DeviceFragment.fileExplorer:
        return const EventLogFragment();
    }
  }
}

class DeviceSection extends StatefulWidget {
  final void Function(DeviceFragment fragment) onCardPressed;

  const DeviceSection({Key? key, required this.onCardPressed})
      : super(key: key);

  @override
  State<DeviceSection> createState() => _DeviceSectionState();
}

class _DeviceSectionState extends State<DeviceSection> {
  late DeviceDataConnection _dataConnection;

  @override
  void initState() {
    _dataConnection = locator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          maxCrossAxisExtent: 250),
      children: [
        DeviceFragment.logs,
        DeviceFragment.messages,
        DeviceFragment.callHistory,
        DeviceFragment.fileExplorer,
      ]
          .map((e) => TextElevatedButton(
              text: e.title,
              onPressed: () {
                widget.onCardPressed(e);
              }))
          .toList(growable: false),
    );
  }
}