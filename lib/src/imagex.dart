import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:imagex/src/routewrapper.dart';
import 'package:imagex/src/thumbnail.dart';

import 'item.dart';

class ImageX extends StatelessWidget {
  ImageX({required this.items, super.key});

  final List<ImageXItem> items;
  final _pc = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pc,
      children: [
        ...items.mapIndexed(
            (i, e) => ImageXThumbnail(item: e, onTap: () => open(context, i)))
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
        return ImageXRouteWrapper(
          items: items,
          initialIndex: index,
        );
      },
    ));
  }
}
