import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:photox/src/page_indicator.dart';
import 'package:photox/src/routewrapper.dart';
import 'package:photox/src/thumbnail.dart';
import 'package:photox/src/dismissmode.dart';

import 'item.dart';

class PhotoX extends StatelessWidget {
  PhotoX(
      {required this.items,
      this.dismissMode = DismissMode.swipeAny,
      this.showPageIndicator = true,
      this.pageIndicatorAlignment,
      this.pageIndicatorActiveColor,
      this.pageIndicatorBackgroundColor,
      this.pageIndicatorBubblePadding,
      this.pageIndicatorBubbleRadius,
      this.pageIndicatorInactiveColor,
      super.key})
      : assert(!(dismissMode == DismissMode.swipeAny && items.length >= 2),
            "Must provide only 1 item when using DismissMode.swipeAny");

  final List<PhotoXItem> items;
  final DismissMode dismissMode;
  final bool showPageIndicator;
  final AlignmentGeometry? pageIndicatorAlignment;
  final Color? pageIndicatorActiveColor;
  final Color? pageIndicatorInactiveColor;
  final double? pageIndicatorBubbleRadius;
  final EdgeInsetsGeometry? pageIndicatorBubblePadding;
  final Color? pageIndicatorBackgroundColor;

  final _pc = PageController();
  @override
  Widget build(BuildContext context) {
    final pageNotifier = ValueNotifier<int>(0);

    _pc.addListener(() {
      if (_pc.page != null) {
        pageNotifier.value = _pc.page!.round();
      }
    });

    return Stack(
      children: [
        PageView(
          controller: _pc,
          children: [
            ...items.mapIndexed((i, e) =>
                PhotoxThumbnail(item: e, onTap: () => open(context, i)))
          ],
        ),
        if (items.length > 1 && showPageIndicator)
          Align(
            alignment: pageIndicatorAlignment ??
                Alignment(
                    Alignment.bottomCenter.x, Alignment.bottomCenter.y - 0.03),
            child: ValueListenableBuilder<int>(
              valueListenable: pageNotifier,
              builder: (context, currentPage, _) {
                return PageIndicator(
                  activeColor: pageIndicatorActiveColor ?? Colors.white,
                  inactiveColor: pageIndicatorInactiveColor ?? Colors.grey,
                  backgroundColor: pageIndicatorBackgroundColor ??
                      Colors.black.withOpacity(0.4),
                  bubblePadding:
                      pageIndicatorBubblePadding ?? const EdgeInsets.all(5),
                  bubbleRadius: pageIndicatorBubbleRadius ?? 10,
                  length: items.length,
                  position: currentPage,
                );
              },
            ),
          )
      ],
    );
  }

  void open(BuildContext context, final int index) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      fullscreenDialog: true,
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0),
      //transitionDuration: Duration(milliseconds: 0),
      pageBuilder: (context, a, b) {
        return PhotoxRouteWrapper(
          items: items,
          initialIndex: index,
          dismissMode: dismissMode,
        );
      },
    ));
  }
}
