import 'package:flutter/material.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/ui/ui_utils.dart';

class DeviceItemLayout extends StatelessWidget {
  final DeviceModel deviceModel;
  final VoidCallback onPressed;
  final bool isSelected;

  const DeviceItemLayout(
      {Key? key,
      required this.deviceModel,
      this.isSelected = false,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Card(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceVariant,
        clipBehavior: Clip.antiAlias,
        // decoration: BoxDecoration(
        //   color: Theme.of(context).colorScheme.surface,
        //   borderRadius: BorderRadius.circular(20)
        // ),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    deviceModel.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Text(
                      deviceModel.createdOn.displayDate(),
                      style: Theme.of(context).textTheme.caption,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
