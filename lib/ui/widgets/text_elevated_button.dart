
import 'package:flutter/material.dart';

class TextElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  const TextElevatedButton({Key? key, required this.text, required this.onPressed, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5))
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
