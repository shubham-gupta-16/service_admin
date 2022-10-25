import 'package:flutter/material.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/utils/utils.dart';

import '../../api/models/event_model.dart';

class EventItemLayout extends StatelessWidget {
  final EventModel eventModel;
  final VoidCallback onPressed;

  const EventItemLayout(
      {Key? key, required this.eventModel, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (eventModel.event == -1) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return InkWell(
      onTap: onPressed,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 5,
            bottom: 5,
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                  color: getEventColor(eventModel.event).withOpacity(0.8), borderRadius: BorderRadius.circular(4)),
            ),
          ),
          Container(
            width: double.infinity,
            color: getEventColor(eventModel.event).withOpacity(0.03),
            padding: const EdgeInsets.only(right: 20, top: 20, bottom: 20,left: 25),
            child: Text(
              "${eventModel.text ?? ''} - ${eventModel.desc ?? ''}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 8,
            child: Text(eventModel.timestampAsKey.displayDate(),
                style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }

  Color getEventColor(int event) {
    switch (event) {
      case 1:
        return Colors.green;
      case 8:
        return Colors.red;
      case 16:
        return Colors.blue;
      default:
        return Colors.amber;
    }
  }
}
