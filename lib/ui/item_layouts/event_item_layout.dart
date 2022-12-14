import 'package:flutter/material.dart';
import 'package:service_admin/ui/ui_utils.dart';
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
                  color: EventModel.getEventColor(eventModel.event).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          Container(
            width: double.infinity,
            color: EventModel.getEventColor(eventModel.event).withOpacity(0.03),
            padding:
                const EdgeInsets.only(right: 20, top: 20, bottom: 20, left: 25),
            child: Text(
              "${eventModel.text ?? ''} - ${eventModel.desc ?? ''}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 8,
            child: Text(eventModel.timestampAsKey.toTime(),
                style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }


}
