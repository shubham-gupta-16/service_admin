import 'package:flutter/material.dart';
import 'package:service_admin/api/models/call_history_model.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/ui/ui_utils.dart';
import 'package:service_admin/api/utils.dart';

import '../../api/models/event_model.dart';

class CallHistoryItemLayout extends StatelessWidget {
  final CallHistoryModel model;
  final VoidCallback onPressed;

  const CallHistoryItemLayout(
      {Key? key, required this.model, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(
        getIcon(model.type),
        color: getIconColor(model.type),
      ),
      title: Text(model.tempName ?? model.number),
      subtitle: Text(
          "${model.duration.formatDuration()} - ${model.timestamp.formatDate()}"),
    );
  }

  Color getIconColor(int type) {
    switch (type) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      case 5:
        return Colors.red;
      default:
        return Colors.amber;
    }
  }

  IconData getIcon(int type) {
    switch (type) {
      case 1:
        return Icons.call_received;
      case 2:
        return Icons.call_made;
      case 3:
        return Icons.call_missed;
      default:
        return Icons.not_interested;
    }
  }
}
