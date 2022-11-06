import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:service_admin/api/device_data_connection.dart';
import 'package:service_admin/di/locator.dart';
import 'package:service_admin/api/event_log_listener.dart';
import 'package:service_admin/api/models/contact_model.dart';
import 'package:service_admin/ui/item_layouts/contact_item_layout.dart';
import 'package:service_admin/ui/item_layouts/event_item_layout.dart';
import 'package:service_admin/ui/pages/device/device_section.dart';
import 'package:service_admin/ui/pages/device/fragments/contacts/provider/contacts_provider.dart';
import 'package:service_admin/ui/widgets/chip_tab_bar.dart';
import 'package:service_admin/ui/widgets/text_elevated_button.dart';

import '../../../../../api/models/event_model.dart';

class ContactsFragment extends StatefulWidget {
  const ContactsFragment._({Key? key}) : super(key: key);

  static Widget providerWrapped() => ChangeNotifierProvider.value(
    value: ContactsProvider(),
    child: const ContactsFragment._(),
  );

  @override
  State<ContactsFragment> createState() => _ContactsFragmentState();
}

class _ContactsFragmentState extends State<ContactsFragment> {
  late DeviceDataConnection _dataConnection;
  late TextEditingController _searchController;

  @override
  void initState() {
    _dataConnection = locator();
    _searchController = TextEditingController();
    super.initState();

    _searchController.addListener(() {
      context.read<ContactsProvider>().setSearchText(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DeviceFragment.contacts.title),
        actions: [
          Container(
            constraints: const BoxConstraints(
              maxWidth: 300
            ),
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  fillColor:
                  Theme.of(context).colorScheme.secondaryContainer,
                  filled: true,
                  hintText: "Search Contacts..."),
            ),
          )
        ],
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
    final provider = context.watch<ContactsProvider>();
    final newList = provider.getFilteredList(list);
    return ListView.builder(
      itemBuilder: (context, index) {
        final eventModel = newList[index];
        return ContactItemLayout(
          model: eventModel,
          onPressed: () {},
        );
      },
      itemCount: newList.length,
    );
  }
}
