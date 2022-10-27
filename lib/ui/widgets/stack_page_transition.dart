
import 'package:flutter/material.dart';

class StackPageTransition extends StatelessWidget {
  final Widget child;
  final Widget? overlayChild;
  const StackPageTransition({Key? key, required this.overlayChild, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedScale(
          scale: overlayChild != null ? 1.05 : 1,
          duration: const Duration(milliseconds: 160),
          child: child,
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 160),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1)
                      .animate(animation),
                  child: child),
            );
          },
          child: overlayChild ?? const SizedBox(),
        )
      ],
    );
  }
}
