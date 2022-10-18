
import 'package:flutter/material.dart';
import 'package:service_admin/api/models/device_model.dart';
import 'package:service_admin/utils/utils.dart';

class DeviceItemLayout extends StatelessWidget {
  final DeviceModel deviceModel;
  final VoidCallback onPressed;
  const DeviceItemLayout({Key? key, required this.deviceModel, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text("${deviceModel.name} - ${deviceModel.status == 0 ? "Offline" : "Online"}",
                style: Theme.of(context).textTheme.bodyLarge,),
              ),
              Positioned(
                top: 0,
                  right: 0,
                  child: Text(deviceModel.lastSeen.displayDate())),
            ],
          ),
        ),
      ),
    );
  }
}
