import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:service_admin/api/new_device_connector.dart';
import 'package:service_admin/ui/ui_utils.dart';
import '../../../di/locator.dart';

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
          child: _OnlyBottomCursor(
        onPinFilled: (code) {},
      )),
    );
  }
}

class _OnlyBottomCursor extends StatefulWidget {
  final void Function(String code) onPinFilled;

  const _OnlyBottomCursor({Key? key, required this.onPinFilled})
      : super(key: key);

  @override
  _OnlyBottomCursorState createState() => _OnlyBottomCursorState();

  @override
  String toStringShort() => 'With Bottom Cursor';
}

class _OnlyBottomCursorState extends State<_OnlyBottomCursor> {
  late NewDeviceConnector connector;
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    connector = locator();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    connector.close();
    super.dispose();
  }

  // business login here
  Future<void> _verifyCode(String code) async {
    context.showLoaderDialog();
    final res = await connector.verifyCode(code);
    if (!mounted) return;
    context.navigatePop();
    //todo show loader
    print(res);
    if (res) {
      context.navigatePop();
    } else {
      context.showSnackBar("Wrong code or network error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: Theme.of(context).textTheme.headline6,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 21,
        height: 2,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Enter Code', style: Theme.of(context).textTheme.headline5,),
        const SizedBox(height: 40,),
        Pinput(
          length: 6,
          controller: controller,
          focusNode: focusNode,
          defaultPinTheme: defaultPinTheme,
          separator: const SizedBox(width: 8),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05999999865889549),
                  offset: Offset(0, 3),
                  blurRadius: 16,
                )
              ],
            ),
          ),
          onCompleted: _verifyCode,
          // onClipboardFound: (value) {
          //   debugPrint('onClipboardFound: $value');
          //   controller.setText(value);
          // },
          showCursor: true,
          cursor: cursor,
        ),
        const SizedBox(height: 40,),

      ],
    );
  }
}
