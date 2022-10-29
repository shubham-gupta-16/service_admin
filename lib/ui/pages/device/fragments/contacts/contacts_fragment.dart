import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/api/di/locator.dart';
import 'package:service_admin/api/event_log_listener.dart';
import 'package:service_admin/api/models/contact_model.dart';
import 'package:service_admin/ui/item_layouts/contact_item_layout.dart';
import 'package:service_admin/ui/item_layouts/event_item_layout.dart';
import 'package:service_admin/ui/pages/device/device_section.dart';
import 'package:service_admin/ui/widgets/chip_tab_bar.dart';
import 'package:service_admin/ui/widgets/text_elevated_button.dart';

import '../../../../../api/models/event_model.dart';

class ContactsFragment extends StatefulWidget {
  const ContactsFragment({Key? key}) : super(key: key);

  @override
  State<ContactsFragment> createState() => _ContactsFragmentState();
}

class _ContactsFragmentState extends State<ContactsFragment> {
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
        title: Text(DeviceFragment.logs.title),
      ),
      body: FutureBuilder(
          future: _dataConnection.getContacts(),
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
            return _ContactsListView(list: future.requireData);
          }),
    );
  }
}

class _ContactsListView extends StatelessWidget {
  final List<ContactModel> list;

  const _ContactsListView({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final eventModel = list[index];
        return ContactItemLayout(
          model: eventModel,
          onPressed: () {},
        );
      },
      itemCount: list.length,
    );
  }
}
