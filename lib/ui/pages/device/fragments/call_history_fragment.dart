import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/ui/item_layouts/call_history_item_layout.dart';
import 'package:service_admin/ui/pages/device/device_section.dart';

class CallHistoryFragment extends StatefulWidget {
  const CallHistoryFragment({Key? key}) : super(key: key);

  @override
  State<CallHistoryFragment> createState() => _CallHistoryFragmentState();
}

class _CallHistoryFragmentState extends State<CallHistoryFragment> {
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
        title: Text(DeviceFragment.callHistory.title),
      ),
      body: FutureBuilder(
          future: _dataConnection.getCallHistory(),
          builder: (context, future) {
            if (future.data == null || future.requireData.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final callHistoryModel = future.requireData[index];
                return CallHistoryItemLayout(
                  model: callHistoryModel,
                  onPressed: () {},
                );
              },
              itemCount: future.requireData.length,
            );
          }),
    );
  }
}
