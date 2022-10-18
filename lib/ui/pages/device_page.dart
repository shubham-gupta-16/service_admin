import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/ui/pages/features/event_log_page.dart';
import 'package:service_admin/utils/utils.dart';

import '../../api/di/provider_di.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          children: [
            ElevatedButton(
              child: const Text('Event Logs'),
              onPressed: () {
                context.navigatePush(const EventLogPage());
              },
            ),
            ElevatedButton(
              child: const Text('Messages'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: const Text('Call History'),
              onPressed: () {},
            ),
            ElevatedButton(
              child: const Text('File Explorer'),
              onPressed: () {},
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
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
      ),
    );
  }
}
