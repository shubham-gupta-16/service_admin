import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/models/call_history_model.dart';
import 'package:service_admin/ui/item_layouts/call_history_item_layout.dart';
import 'package:service_admin/ui/pages/device/device_section.dart';
import 'package:service_admin/ui/pages/device/fragments/call_history/provider/call_history_provider.dart';
import 'package:service_admin/ui/widgets/chip_tab_bar.dart';
import 'package:service_admin/ui/widgets/text_elevated_button.dart';

class CallHistoryFragment extends StatefulWidget {
  const CallHistoryFragment._({Key? key}) : super(key: key);

  static Widget providerWrapped() => ChangeNotifierProvider.value(
        value: CallHistoryProvider(),
        child: const CallHistoryFragment._(),
      );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DeviceFragment.callHistory.title),
      ),
      body: Column(
        children: [
          ChipTabBar(
            tabs: context
                .read<CallHistoryProvider>()
                .typeFilterList
                .map((e) => Text(e))
                .toList(growable: false),
            controller: chipTabController,
            onChange: (index) {
              context.read<CallHistoryProvider>().setTypeByIndex(index);
            },
          ),
          Expanded(
            child: FutureBuilder(
                future: _dataConnection.getCallHistory(),
                builder: (context, future) {
                  if (future.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (future.hasError || future.data == null) {
                    return Center(
                        child: TextElevatedButton.text(
                      text: future.error.toString(),
                      onPressed: () {
                        setState(() {});
                      },
                    ));
                  }
                  if (future.requireData.isEmpty) {
                    return const Center(child: Text('No Records found!'));
                  }
                  return _CallHistoryListView(list: future.requireData);
                }),
          ),
        ],
      ),
    );
  }
}

class _CallHistoryListView extends StatelessWidget {
  final List<CallHistoryModel> list;

  const _CallHistoryListView({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = context.watch<CallHistoryProvider>().type;

    final filteredList = type > 0
        ? list.where((element) => element.type == type).toList(growable: false)
        : list;

    return ListView.builder(
      itemBuilder: (context, index) {
        final callHistoryModel = filteredList[index];
        return CallHistoryItemLayout(
          model: callHistoryModel,
          onPressed: () {},
        );
      },
      itemCount: filteredList.length,
    );
  }
}
