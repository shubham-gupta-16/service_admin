import 'package:flutter/material.dart';

import 'text_elevated_button.dart';

class ChipTabController extends ChangeNotifier {
  final int initialIndex;
  int currentIndex = 0;

  ChipTabController({this.initialIndex = 0}) {
    currentIndex = initialIndex;
    print('init');
  }

  updateIndex(int index) {
    print('updateIndex');
    currentIndex = index;
    notifyListeners();
  }
}

class ChipTabBar extends StatefulWidget {
  final List<Widget> tabs;
  final ChipTabController controller;
  final void Function(int index)? onChange;
  final bool Function(int index)? onTap;

  const ChipTabBar(
      {Key? key,
      required this.tabs,
      this.onChange,
      this.onTap,
      required this.controller})
      : super(key: key);

  @override
  State<ChipTabBar> createState() => _ChipTabBarState();
}

class _ChipTabBarState extends State<ChipTabBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_stateListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tabs.isNotEmpty && widget.onChange != null) {
        // widget.onChange!(currentIndex);
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_stateListener);
    super.dispose();
  }

  void _stateListener() {
    if (mounted) {
      print("updated");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabs.isEmpty) return const SizedBox();
    return Container(
      color: Theme.of(context).colorScheme.background,
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: widget.tabs
              .asMap()
              .entries
              .map((e) => Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: TextElevatedButton(
                        backgroundColor:
                            (e.key == widget.controller.currentIndex)
                                ? Theme.of(context).colorScheme.primaryContainer
                                : null,
                        onPressed: () {
                          bool b = true;
                          if (widget.onTap != null) {
                            b = widget.onTap!(e.key);
                          }
                          if (widget.onChange != null) {
                            widget.onChange!(e.key);
                          }
                          // if(b) {
                          widget.controller.updateIndex(e.key);
                          print('press');
                          // }
                        },
                        child: e.value),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
