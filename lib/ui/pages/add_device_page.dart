import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_admin/api/new_device_connetor.dart';
import 'package:service_admin/ui/widgets/text_elevated_button.dart';
import 'package:service_admin/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/di/locator.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  late NewDeviceConnector connector;

  @override
  void initState() {
    connector = locator();
    super.initState();
  }

  @override
  void dispose() {
    connector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: connector.createNewLink(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: TextElevatedButton(
                  text: snapshot.requireData.toString(),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: snapshot.requireData.toString()));
                    if (!mounted) return;
                    context.showSnackBar("Code Copied");
                  },
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
