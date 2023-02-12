import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:photox/src/routewrapper.dart';
import 'package:photox/src/thumbnail.dart';
import 'package:photox/src/dismissmode.dart';

import 'item.dart';

class PhotoX extends StatelessWidget {
  PhotoX(
      {required this.items, this.dismissMode = DismissMode.swipeAny, super.key})
      : assert(!(dismissMode == DismissMode.swipeAny && items.length >= 2),
            "Must provide only 1 item when using DismissMode.swipeAny");

  final List<PhotoXItem> items;
  final DismissMode dismissMode;
  final _pc = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pc,
      children: [
        ...items.mapIndexed(
            (i, e) => PhotoxThumbnail(item: e, onTap: () => open(context, i)))
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
