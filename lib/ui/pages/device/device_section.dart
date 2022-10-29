import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/ui/pages/device/fragments/call_history/call_history_fragment.dart';
import 'package:service_admin/ui/pages/device/fragments/contacts/contacts_fragment.dart';

import '../../../api/di/locator.dart';
import '../../widgets/text_elevated_button.dart';
import 'fragments/event_log/event_log_fragment.dart';

enum DeviceFragment {
  logs,
  messages,
  callHistory,
  fileExplorer,
  contacts
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
      case DeviceFragment.contacts:
        return "Contacts";
    }
  }

  Widget get widget {
    switch (this) {
      case DeviceFragment.logs:
        return const EventLogFragment();
      case DeviceFragment.messages:
        return const SizedBox();
      case DeviceFragment.callHistory:
        return CallHistoryFragment.providerWrapped();
      case DeviceFragment.fileExplorer:
        return const SizedBox();
      case DeviceFragment.contacts:
        return const ContactsFragment();
    }
  }
}

class DeviceSection extends StatefulWidget {
  final void Function(DeviceFragment fragment) onCardPressed;
  final bool isDesktop;
  const DeviceSection(
      {Key? key, required this.onCardPressed, required this.isDesktop})
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
    return Scaffold(
      appBar: AppBar(
        leadingWidth: widget.isDesktop ? 0 : null,
        leading: widget.isDesktop ? const SizedBox() : null,
        title: Text(_dataConnection.requireDeviceModel.name),
      ),
      body: GridView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 10, crossAxisSpacing: 10, maxCrossAxisExtent: 250),
        children: DeviceFragment.values
            .map((e) => TextElevatedButton.text(
                text: e.title,
                onPressed: () {
                  widget.onCardPressed(e);
                }))
            .toList(growable: false),
      ),
    );
  }
}
