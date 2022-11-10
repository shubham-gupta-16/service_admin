import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/di/locator.dart';
import 'package:service_admin/api/models/call_history_model.dart';
import 'package:service_admin/ui/item_layouts/call_history_item_layout.dart';
import 'package:service_admin/ui/pages/device/device_section.dart';
import 'package:service_admin/ui/pages/device/fragments/call_history/provider/call_history_provider.dart';
import 'package:service_admin/ui/ui_utils.dart';
import 'package:service_admin/ui/widgets/chip_tab_bar.dart';
import 'package:service_admin/ui/widgets/text_elevated_button.dart';

import '../../../../../api/command.dart';

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
  StreamSubscription? _replySubs;

  @override
  void initState() {
    chipTabController = ChipTabController();
    _dataConnection = locator();
    _replySubs = _dataConnection.replyStream.listen((cmdReply) {
      if (cmdReply.code == Command.callHistory && cmdReply.deviceKey == _dataConnection.deviceKey) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _replySubs?.cancel();
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
    final provider = context.watch<CallHistoryProvider>();

    final filteredList = provider.type > 0
        ? list.where((element) => element.type == provider.type).toList(growable: false)
        : list;

    final map = {};
    for (final model in filteredList){
      final date = model.timestamp.toDate();
      if (!map.containsKey(date)) {
        map[date] = [];
      }
      map[date]!.add(model);
    }

    return CustomScrollView(
      slivers: map.entries.map((e) => SliverStickyHeader(
        header: SizedBox(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Text(
                e.key,
              ),
            ),
          ),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) => CallHistoryItemLayout(
                  model: e.value[i],
                  onPressed: () {},
                ),
            childCount: e.value.length,
          ),
        ),
      )).toList(growable: false),
    );
  }
}
