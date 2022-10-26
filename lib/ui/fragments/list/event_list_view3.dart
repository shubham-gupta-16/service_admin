import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../api/models/event_model.dart';
import '../../item_layouts/event_item_layout.dart';

class StickyDateListView extends StatefulWidget {
  final List<EventModel> list;
  final Widget Function(String value) header;
  final Future<void> Function()? onLoadMore;

  const StickyDateListView({Key? key, required this.list, required this.header, this.onLoadMore})
      : super(key: key);

  @override
  State<StickyDateListView> createState() => _StickyDateListViewState();
}

class _StickyDateListViewState extends State<StickyDateListView> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final controller = ScrollController();

  final List<double> vList = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
    // itemPositionsListener.itemPositions.addListener(_scrollListener);
  }
  
  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    // itemPositionsListener.itemPositions.removeListener(_scrollListener);
    super.dispose();
  }

  bool isLoadingMore = false;

  void _scrollListener() {
    final index = vList.lastIndexWhere((element) => element != 0);
    print("List: ${widget.list.length}, $index, ${_getDateByIndex(index)}");
    if (topIndex != index){
      if (index == widget.list.length - 1 && widget.onLoadMore != null && !isLoadingMore){
        _fetchMore();
      }
      setState(() {
        topIndex = index;
      });
    }
  }

  Future<void> _fetchMore() async {
    isLoadingMore = true;
    await widget.onLoadMore!();
    isLoadingMore = false;
  }
  
  int topIndex = -1;

  @override
  Widget build(BuildContext context) {

    if (vList.length != widget.list.length) {
      vList.clear();

      for (var _ in widget.list) {
        vList.add(0);
      }
    }

    // print(topIndex);
    final date = _getDateByIndex(topIndex);
    return Stack(
      children: [
        ListView.builder(
          controller: controller,
          reverse: true,
          itemBuilder: (context, index) {
            final eventModel = widget.list[index];

            final Widget view = EventItemLayout(
              eventModel: eventModel,
              onPressed: () {},
            );


            // final newDate = formatter.format(
            //     DateTime.fromMillisecondsSinceEpoch(eventModel.timestampAsKey));

            final newDate = _getDate(eventModel);
            final date = _getDateByIndex(index + 1);

            final Widget column;
            if (newDate != date){
              column = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.header(newDate),
                  view,
                ],
              );
            } else {
              column = view;
            }
            return VisibilityDetector(key: Key(eventModel.timestampAsKey.toString()),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;
                  vList[index] = visibilityInfo.visibleFraction;
                  debugPrint(
                      'Widget $index -> ${visibilityInfo.key} is ${visiblePercentage}% visible');
                },
                child: column);
          },
          itemCount: widget.list.length,
        ),
        if (date != null) widget.header(date),
      ],
    );
  }

  String? _getDateByIndex(int index){
    final model = (index >= 0 && index < widget.list.length) ? widget.list[index] : null;
    if(model == null) return null;
    return _getDate(model);
  }

  String _getDate(EventModel model){
    return formatter.format(DateTime.fromMillisecondsSinceEpoch(model.timestampAsKey));
    return "${model.event}***********";
  }
}
