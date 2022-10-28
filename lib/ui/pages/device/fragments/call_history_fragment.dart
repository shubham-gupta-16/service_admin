import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/ui/item_layouts/call_history_item_layout.dart';
import 'package:service_admin/ui/pages/device/device_section.dart';
import 'package:service_admin/ui/widgets/chip_tab_bar.dart';

class CallHistoryFragment extends StatefulWidget {
  const CallHistoryFragment({Key? key}) : super(key: key);

  @override
  State<CallHistoryFragment> createState() => _CallHistoryFragmentState();
}

class _CallHistoryFragmentState extends State<CallHistoryFragment> {
  late DeviceDataConnection _dataConnection;
  late ChipTabController chipTabController;

  @override
  void initState() {
    chipTabController = ChipTabController();
    _dataConnection = locator();
    super.initState();
  }

  @override
  void dispose() {
    chipTabController.dispose();
    super.dispose();
  }

  int _filter = 0;

  int _getTypeByFilter() {
    switch (_filter) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 3;
      case 4:
        return 5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DeviceFragment.callHistory.title),
      ),
      body: Column(
        children: [
          ChipTabBar(
            tabs: ['All', 'Received', 'Dialed', 'Missed', 'Rejected']
                .map((e) => Text(e))
                .toList(growable: false),
            controller: chipTabController,
            onChange: (index) {
              setState(() {
                _filter = index;
              });
            },
          ),
          Expanded(
            child: FutureBuilder(
                future: _dataConnection.getCallHistory(),
                builder: (context, future) {
                  if (future.data == null || future.requireData.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final type = _getTypeByFilter();
                  final list = type > 0
                      ? future.requireData
                          .where((element) => element.type == type).toList(growable: false)
                      : future.requireData;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final callHistoryModel = list[index];
                      return CallHistoryItemLayout(
                        model: callHistoryModel,
                        onPressed: () {},
                      );
                    },
                    itemCount: list.length,
                  );
                }),
          ),
        ],
      ),
    );
  }
}
