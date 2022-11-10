import 'package:flutter/material.dart';
import 'package:service_admin/api/models/call_history_model.dart';
import 'package:service_admin/api/models/contact_model.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/api/models/message_model.dart';
import 'package:service_admin/ui/ui_utils.dart';
import 'package:service_admin/api/utils.dart';

import '../../api/models/event_model.dart';

class MessageItemLayout extends StatelessWidget {
  final MessageModel model;
  final VoidCallback onPressed;

  const MessageItemLayout(
      {Key? key, required this.model, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(
        model.type == 0 ? Icons.inbox : Icons.outbox
      ),
      onLongPress: (){
        context.showSnackBar(model.message);
      },
      title: Text(model.from),
      subtitle: Text(model.timestamp.displayDate()),
    );
  }
}
