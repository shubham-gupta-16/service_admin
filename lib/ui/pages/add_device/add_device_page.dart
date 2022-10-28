import 'package:flutter/material.dart';
import 'package:service_admin/api/new_device_connetor.dart';
import 'package:service_admin/ui/ui_utils.dart';
import 'package:service_admin/ui/widgets/auth_text_field.dart';
import '../../../api/di/locator.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  late NewDeviceConnector connector;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    connector = locator();
    _textEditingController = TextEditingController();
    super.initState();
    _textEditingController.addListener(_onTextChange);
  }

  Future<void> _onTextChange() async {
    final text = _textEditingController.text;
    if (text.length == 6) {
      final res = await connector.verifyCode(text);
      //todo show loader
      print(res);
      if (res) {
        if (!mounted) return;
        context.navigatePop();
      }
    }
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onTextChange);
    _textEditingController.dispose();
    connector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: SizedBox(
        width: 250,
        child: AuthTextField(
          controller: _textEditingController,
          hint: "Code",
          maxLength: 6,
          type: AuthTextFieldType.number,
          textAlign: TextAlign.center,
        ),
      )),
    );
  }
}
