import 'package:flutter/material.dart';
import 'package:service_admin/api/device_data_connection.dart';
import '../../api/di/locator.dart';
import '../sections/device_section.dart';

class DevicePage extends StatefulWidget {
  final bool isDesktop;
  const DevicePage({Key? key, required this.isDesktop}) : super(key: key);

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late DeviceDataConnection _dataConnection;
  late TextEditingController _textEditingController;


  @override
  void initState() {
    _dataConnection = locator();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // _dataConnection.close();
    super.dispose();
  }

  ///////////////////////// FRAGMENT STATE /////////////////////////
  DeviceFragment? fragment;

  void switchFragment(DeviceFragment fragment){
    ModalRoute.of(context)?.addLocalHistoryEntry(
        LocalHistoryEntry(
            onRemove: () {
              setState(() => this.fragment = null);
            }
        )
    );
    setState(() {
      this.fragment = fragment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                DeviceSection(onCardPressed: (fragment) {
                  switchFragment(fragment);
                },),
                AnimatedSwitcher(duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  print(animation);
                  return ScaleTransition(scale: animation,
                  child: FadeTransition(opacity: animation, child: child,));
                },
                child: fragment?.widget ?? const SizedBox(),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        fillColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                        filled: true,
                        hintText: "Command"),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                IconButton(
                    onPressed: () {
                      _dataConnection
                          .runCommand(_textEditingController.text.trim());
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          )
        ],
      )
    );
  }
}
