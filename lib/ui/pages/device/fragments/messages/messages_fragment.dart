import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/models/message_model.dart';
import 'package:service_admin/di/locator.dart';
import 'package:service_admin/api/models/contact_model.dart';
import 'package:service_admin/ui/item_layouts/contact_item_layout.dart';
import 'package:service_admin/ui/item_layouts/message_item_layout.dart';
import 'package:service_admin/ui/pages/home/providers/screen_mode_provider.dart';
import 'package:service_admin/ui/widgets/text_elevated_button.dart';

import 'provider/messages_provider.dart';


class MessagesFragment extends StatefulWidget {
  const MessagesFragment._({Key? key}) : super(key: key);

  static Widget providerWrapped() => ChangeNotifierProvider.value(
    value: MessagesProvider(),
    child: const MessagesFragment._(),
  );

  @override
  State<MessagesFragment> createState() => _MessagesFragmentState();
}

class _MessagesFragmentState extends State<MessagesFragment> {
  late DeviceDataConnection _dataConnection;

  @override
  void initState() {
    _dataConnection = locator();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenMode = context.watch<ScreenModeProvider>().mode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: FutureBuilder(
          future: _dataConnection.getMessages(),
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
            return _MessagesListView(list: future.requireData);
          }),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  final List<MessageModel> list;

  const _MessagesListView({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final model = list[index];
        return MessageItemLayout(
          model: model,
          onPressed: () {},
        );
      },
      itemCount: list.length,
    );
  }
}
