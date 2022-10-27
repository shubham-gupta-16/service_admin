import 'package:flutter/material.dart';

class TextElevatedButton extends StatelessWidget {
  final Widget? child;
  final String? text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  const TextElevatedButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.width,
      this.height,
      this.text,
      this.backgroundColor})
      : super(key: key);

  const TextElevatedButton.text(
      {super.key,
      required this.text,
      required this.onPressed,
      this.width,
      this.height,
      this.backgroundColor})
      : child = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(backgroundColor ?? Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withOpacity(0.5))),
        onPressed: onPressed,
        child: child ?? (text != null ? Text(text!) : const SizedBox()),
      ),
    );
  }
}
