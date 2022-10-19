import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/ui/pages/features/event_log_page.dart';
import 'package:service_admin/utils/utils.dart';

import '../../api/di/provider_di.dart';
import '../widgets/text_elevated_button.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key? key}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late DeviceDataConnection _dataConnection;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _dataConnection = locator();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dataConnection.deviceModel.name),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: GridView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              children: [
                TextElevatedButton(
                  text: 'Event Logs',
                  onPressed: () {
                    context.navigatePush(const EventLogPage());
                  },
                ),
                TextElevatedButton(
                  text: 'Messages',
                  onPressed: () {
                  },
                ),
                TextElevatedButton(
                  text: 'Call History',
                  onPressed: () {
                  },
                ),
                TextElevatedButton(
                  text: 'File Explorer',
                  onPressed: () {
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none
                        ),
                        fillColor: Theme.of(context).colorScheme.secondaryContainer,
                        filled: true,
                        hintText: "Command"
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                IconButton(onPressed: () {
                  _dataConnection.runCommand(_textEditingController.text.trim());
                }, icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      ),
    );
  }
}
