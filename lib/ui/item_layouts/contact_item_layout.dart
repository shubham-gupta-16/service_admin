import 'package:flutter/material.dart';
import 'package:service_admin/api/models/call_history_model.dart';
import 'package:service_admin/api/models/contact_model.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/ui/ui_utils.dart';
import 'package:service_admin/api/utils.dart';

import '../../api/models/event_model.dart';

class ContactItemLayout extends StatelessWidget {
  final ContactModel model;
  final VoidCallback onPressed;

  const ContactItemLayout(
      {Key? key, required this.model, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: const Icon(
        Icons.account_circle
      ),
      onLongPress: (){
        context.showSnackBar(model.number);
      },
      title: Text(model.name),
      subtitle: Text(model.number),
    );
  }
}
